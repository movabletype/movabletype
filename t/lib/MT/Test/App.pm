package MT::Test::App;

use Role::Tiny::With;
use strict;
use warnings;
use CGI;
use HTTP::Response;
use URI;
use URI::QueryParam;
use Test::More;

with qw(
    MT::Test::Role::Request
    MT::Test::Role::WebQuery
);

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

sub base_url { 'http://localhost' }

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
        $app->param( 'magic_token', $app->current_magic );
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

1;
