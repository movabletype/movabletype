package MT::Test::Role::Request;

use Role::Tiny;
use CGI;
use HTML::Form;
use HTML::LinkExtor;
use Scalar::Util qw/blessed/;
use Test::More;

requires qw/ request base_url /;

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
    $res;
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
    $res;
}

sub post_form_ok {
    my $self = shift;
    my ( $form_id, $params ) = ref $_[0] ? ( undef, @_ ) : @_;
    my $form = $self->form($form_id);
    ok $form, "found form" or return;

    $form->param( $_ => $params->{$_} ) for keys %$params;

    my $res = $self->post( $form->click );
    ok $res->is_success, "post succeeded";
    $res;
}

sub forms {
    my $self = shift;
    HTML::Form->parse(
        $self->content,
        base   => $self->base_url,
        strict => 1,
    );
}

sub form {
    my ( $self, $id ) = @_;
    my @forms = $self->forms;
    return $forms[0] unless $id;
    my ($form) = grep { ( $_->attr('id') // '' ) eq $id } @forms;
    $form;
}

sub links {
    my $self = shift;
    my @links;
    my $p = HTML::LinkExtor->new(sub {
        my ($tag, %attr) = @_;
        push @links, $attr{href} if $attr{href};
    });
    $p->parse($self->content);
    @links;
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

1;
