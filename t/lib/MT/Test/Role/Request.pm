package MT::Test::Role::Request;

use Role::Tiny;
use CGI;
use HTML::Form;
use HTML::LinkExtor;
use Scalar::Util qw/blessed/;
use Test::More;
use JSON ();
use HTTP::Request::AsCGI;

requires qw/ request base_url /;

sub _convert_params {
    my $params = shift;
    if ( blessed $params && $params->isa('HTTP::Request') ) {
        my $c = HTTP::Request::AsCGI->new($params)->setup;
        my $param_method = CGI->VERSION < 4 ? 'param' : 'multi_param';
        my $cgi = CGI->new;
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
    my ( $self, $params, $message ) = @_;
    my $res = $self->get($params);
    ok !$res->is_error, $message // "get succeeded";
    my $header_title = $self->header_title();
    note $header_title if $header_title;
    $res;
}

sub post {
    my ( $self, $params ) = @_;
    $params = _convert_params($params);
    $params->{__request_method} = 'POST';
    $self->request($params);
}

sub post_ok {
    my ( $self, $params, $message ) = @_;
    my $res = $self->post($params);
    ok !$res->is_error, $message // "post succeeded";
    my $header_title = $self->header_title();
    note $header_title if $header_title;
    $res;
}

sub post_form_ok {
    my $self = shift;
    my ( $form_id, $params, $message ) = ref $_[0] ? ( undef, @_ ) : @_;
    my $form = $self->form($form_id);
    ok $form, "found form" or return;

    for my $input ( $form->inputs ) {
        my $name = $input->name;
        next unless defined $name;
        next unless exists $params->{$name};
        if ( $input->readonly ) {
            $input->readonly(0);
            note "Set value to readonly field: $name";
        }
        if ($input->type eq 'file') {
            $input->file($params->{$name});
        } else {
            $form->param( $name => $params->{$name} );
        }
    }

    my $res = $self->post( $form->click );
    ok $res->is_success, $message // "post succeeded";
    $res;
}

sub js_get_ok {
    my ( $self, $params, $message ) = @_;
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    $self->get_ok($params, $message);
}

sub js_post_ok {
    my ( $self, $params, $message ) = @_;
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    $self->post_ok($params, $message);
}

sub js_post_form_ok {
    my ( $self, $params, $message ) = @_;
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    $self->post_form_ok($params, $message);
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
    my ( $self, $pattern, $message ) = @_;
    $pattern = qr/\Q$pattern\E/ unless ref $pattern;
    ok $self->content =~ /$pattern/, $message // "content contains $pattern";
}

sub content_unlike {
    my ( $self, $pattern, $message ) = @_;
    $pattern = qr/\Q$pattern\E/ unless ref $pattern;
    ok $self->content !~ /$pattern/, $message // "content doesn't contain $pattern";
}

sub content_doesnt_expose {
    my ( $self, $url ) = @_;
    ok $self->content !~ /(<(a|form|meta|link|img|script)\s[^>]+\Q$url\E[^>]+>)/s
        or note "$url is exposed as $1";
}

sub api_request {
    my ( $self, $method, $path, $params, $body_params ) = @_;
    if ( $method =~ /POST|PUT/i && $params && !ref $params && $body_params && ref $body_params ) {
        my $key = $params;
        $params = {};
        $params->{$key} = JSON::encode_json($body_params);
    }
    $params = _convert_params($params);
    $params->{__path_info}      = $path;
    $params->{__request_method} = $method;
    $self->request($params);
}

sub api_request_ok {
    my $self = shift;
    my $res = $self->api_request(@_);
    my $message = (@_ > 2 && !ref $_[-1]) ? pop @_ : undef;
    ok $res->is_success, $message // "request succeeded";
    return JSON::decode_json($res->decoded_content);
}

sub json {
    my $self = shift;
    return unless $self->{res} && $self->{res}->header('Content-Type') =~ qr{^application/json;};
    return MT::Util::from_json($self->{content});
}

sub html_content {
    my $self = shift;
    my $content = $self->content;
    $content =~ s/\n(\s*\n)+/\n/gs;
    require HTML::Filter::Callbacks;
    my $filter = HTML::Filter::Callbacks->new;
    $filter->add_callbacks(
        script => {
            start => sub { shift->remove_text_and_tag },
            end   => sub { shift->remove_text_and_tag },
        },
    );
    $self->{html_content} = $filter->process($content);
}

sub html_content_like {
    my ( $self, $pattern, $message ) = @_;
    $pattern = qr/\Q$pattern\E/ unless ref $pattern;
    ok $self->html_content =~ /$pattern/, $message // "content contains $pattern";
}

sub html_content_unlike {
    my ( $self, $pattern, $message ) = @_;
    $pattern = qr/\Q$pattern\E/ unless ref $pattern;
    ok $self->html_content !~ /$pattern/, $message // "content doesn't contain $pattern";
}

1;
