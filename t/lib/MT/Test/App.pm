package MT::Test::App;

use strict;
use warnings;
use CGI;
use Cwd qw/abs_path/;
use File::Spec;
use HTTP::Response;
use URI;
use URI::QueryParam;
use Test::More;
use HTML::Form;
use Scalar::Util qw/blessed/;
use Web::Query;

my %Initialized;

sub init {
    my ( $class, $app_class ) = @_;

    return if $Initialized{$app_class};

    eval "require $app_class; 1;" or die "Can't load $app_class";

    # kill __test_output for a new request
    require MT;
    MT->add_callback(
        "${app_class}::init_request",
        1, undef,
        sub {
            $_[1]->{__test_output}    = '';
            $_[1]->{upgrade_required} = 0;
        }
    ) or die( MT->errstr );
    {
        no warnings 'redefine';
        *MT::App::print = sub {
            my $app = shift;
            $app->{__test_output} ||= '';
            $app->{__test_output} .= join( '', @_ );
        };
    }
    $Initialized{$app_class} = 1;
}

sub new {
    my $class = shift;
    my %args  = ( @_ == 1 ) ? ( app_class => shift ) : @_;

    $args{app_class} ||= $ENV{MT_APP} || 'MT::App::CMS';

    $class->init( $args{app_class} );

    bless \%args, $class;
}

sub login {
    my ( $self, $user ) = @_;
    $self->{user} = $user;
}

sub request {
    my ( $self, $params ) = @_;
    local $ENV{HTTP_HOST} = 'localhost';    ## for app->base
    CGI::initialize_globals();
    $self->_clear_cache;

    my $app_params = $self->_app_params($params);
    my $cgi        = $self->_create_cgi_object($params);
    my $app        = $self->{app_class}->new( CGIObject => $cgi );
    MT->set_instance($app);
    $app->{init_request} = 0;
    $app->init_request( CGIObject => $cgi );

    for my $key ( keys %$app_params ) {
        $app->{$key} = $app_params->{$key};
    }

    my $login;
    if ( my $user = $self->{user} ) {
        if ( !$self->{session} ) {
            $app->start_session( $user, 1 );
            $self->{session} = $app->{session}->id;
        }
        else {
            $app->session_user( $user, $self->{session} );
        }
        $app->param( 'magic_token', $self->{session} );
        $app->user($user);
        $login = sub { return ( $user, 0 ) };
    }
    no warnings 'redefine';
    local *MT::App::login = $login if $login;

    $app->run;

    my $out = delete $app->{__test_output};
    my $res = HTTP::Response->parse($out);

    $self->{content} = $res->decoded_content // '';

    # redirect?
    my $location;
    if ( $res->code =~ /^30/ ) {
        $location = $res->headers->header('Location');
    }
    elsif ( $self->{content} =~ /window\.location\s*=\s*(['"])(\S+)\1/ )
    {
        $location = $2;
    }
    if ( $location && !$self->{no_redirect} ) {
        Test::More::note "REDIRECTING TO $location";
        my $uri    = URI->new($location);
        my $params = $uri->query_form_hash;

        # avoid processing multiple requests in a second
        sleep 1;

        return $self->request($params);
    }

    $self->{res} = $res;
}

sub _convert_params {
    my $params = shift;
    if ( blessed $params && $params->isa('HTTP::Request') ) {
        my $param_method = CGI->VERSION < 4 ? 'param' : 'multi_param';
        my $cgi = CGI->new( $params->content );
        my %hash;
        for my $name ( $cgi->$param_method ) {
            my @values = $cgi->$param_method($name);
            $hash{$name} = @values > 1 ? \@values : $values[0];
        }
        return \%hash;
    }
    return $params;
}

sub get {
    my ( $self, $params ) = @_;
    $params = _convert_params($params);
    $params->{__request_method} = 'GET';
    $self->request($params);
}

sub get_ok {
    my ( $self, $params ) = @_;
    my $res = $self->get($params);
    ok $res->is_success, "get succeeded";
}

sub post {
    my ( $self, $params ) = @_;
    $params = _convert_params($params);
    $params->{__request_method} = 'POST';
    $self->request($params);
}

sub post_ok {
    my ( $self, $params ) = @_;
    my $res = $self->post($params);
    ok $res->is_success, "post succeeded";
}

sub forms {
    my $self = shift;
    HTML::Form->parse(
        $self->{content},
        base   => 'http://localhost',
        strict => 1,
    );
}

sub form {
    my ( $self, $id ) = @_;
    my @forms = $self->forms;
    my ($form) = grep { ( $_->attr('id') // '' ) eq $id } @forms;
    $form;
}

my %app_params_mapping = (
    __request_method => 'request_method',
    __path_info      => '__path_info',
);

sub _app_params {
    my ( $self, $params ) = @_;
    my %app_params;
    for my $key ( keys %app_params_mapping ) {
        next unless exists $params->{$key};
        $app_params{ $app_params_mapping{$key} } = delete $params->{$key};
    }
    \%app_params;
}

sub _create_cgi_object {
    my ( $self, $params ) = @_;
    my $cgi = CGI->new;
    while ( my ( $k, $v ) = each %$params ) {
        if ( $k eq '__test_upload' ) {
            my ( $key, $src ) = @$v;
            require CGI::File::Temp;
            my $fh = CGI::File::Temp->new( UNLINK => 1 )
                or die "CGI::File::Temp: $!";
            my $basename = basename($src);
            if ( $^O eq 'MSWin32' ) {
                require Encode;
                Encode::from_to( $basename, 'cp932', 'utf8' );
            }
            $fh->_mp_filename($basename);
            binmode $fh;
            local $/;
            open my $in, '<', $src or die "Can't open $src: $!";
            binmode $in;
            my $body = <$in>;
            close $in;
            print $fh $body;
            seek $fh, 0, 0;
            $cgi->param( $key, $fh );
        }
        else {
            $cgi->param( $k, ref $v eq 'ARRAY' ? @$v : $v );
        }
    }
    $cgi;
}

sub _clear_cache {
    my $self = shift;
    MT::Object->driver->clear_cache;
    MT->instance->request->reset;
}

sub trans {
    my ( $self, $message ) = @_;
    MT->translate($message);
}

sub status_is {
    my ( $self, $code ) = @_;
    is $self->{res}->code, $code, "status is $code";
}

sub status_isnt {
    my ( $self, $code ) = @_;
    isnt $self->{res}->code, $code, "status isn't $code";
}

sub content { shift->{content} // '' }

sub content_like {
    my ( $self, $pattern ) = @_;
    $pattern = qr/\Q$pattern\E/ unless ref $pattern;
    ok $self->content =~ /$pattern/, "content contains $pattern";
}

sub content_unlike {
    my ( $self, $pattern ) = @_;
    $pattern = qr/\Q$pattern\E/ unless ref $pattern;
    ok $self->content !~ /$pattern/, "content doesn't contain $pattern";
}

sub content_doesnt_expose {
    my ( $self, $url ) = @_;
    ok $self->content !~ /(<(a|form|meta|link|img|script)\s[^>]+\Q$url\E[^>]+>)/s
        or note "$url is exposed as $1";
}

sub find {
    my ( $self, $selector ) = @_;
    my $wq = Web::Query->new( $self->content );
    $wq->find($selector);
}

sub _trim {
    my $str = shift;
    $str =~ s/\A\s+//s;
    $str =~ s/\s+\z//s;
    $str;
}

sub page_title {
    my $self = shift;
    _trim( $self->find("#page-title")->text );
}

sub alert_text {
    my $self = shift;
    my $alert_class = MT->version_number >= 7 ? '.alert' : '.msg';
    _trim( $self->find($alert_class)->text );
}

sub generic_error {
    my $self = shift;
    _trim( $self->find("#generic-error")->text );
}

1;
