package MT::WebHook;
use strict;
use warnings;

use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id      => 'integer not null auto_increment',
            label   => 'string(255)',
            blog_id => 'integer not null',
            hook    => 'string(255) not null',
            url     => 'string(255) not null',
            method  => 'string(10) not null',
            headers => 'blob meta',
            body    => 'blob meta',
        },
        child_of    => 'MT::Blog',
        primary_key => 'id',
        datasource  => 'webhook',
        audit       => 1,
        meta        => 1,
        indexes     => { blog_id => 1, },
    }
);

sub class_type {
    'webhook';
}

sub class_label {
    'WebHook';
}

sub class_label_plural {
    'WebHooks';
}

sub list_props {
    +{  id => {
            base  => '__virtual.id',
            order => 100,
        },
        label => {
            label   => 'Name',
            base    => '__virtual.label',
            display => 'force',
            order   => 200,
        },
    };
}

sub list_screens {
    +{  object_label       => 'WebHook',
        primary            => 'label',
        default_sort_key   => 'created_on',
        default_sort_order => 'descend',
    };
}

sub cms_edit {
    my ( $cb, $app, $id, $obj, $param ) = @_;
    my $plugin = MT->component('WebHook');

    $param->{hook_options} = +{ map { $_ => $plugin->translate($_) }
            @{ $plugin->registry('hooks') } };

    $param->{method_options} = $plugin->registry('http_methods');

    if ($obj) {
        $param->{headers} = $obj->headers;
        $param->{body}    = $obj->body;
    }

    1;
}

sub cms_post_save {
    my ( $cb, $app, $obj, $orig ) = @_;

    my @header_keys   = $app->param('header_key');
    my @header_values = $app->param('header_value');
    my $headers       = {};
    for my $key (@header_keys) {
        my $value = shift @header_values;
        last if $key eq '' || $value eq '';
        $headers->{$key} = $value;
    }
    $obj->headers($headers);

    my @body_keys   = $app->param('body_key');
    my @body_values = $app->param('body_value');
    my $body        = {};
    for my $key (@body_keys) {
        my $value = shift @body_values;
        last if $key eq '' || $value eq '';
        $body->{$key} = $value;
    }
    $obj->body($body);

    $obj->save;

    1;
}

sub cms_post_save_entry {
    my ( $cb, $app, $obj, $orig ) = @_;
    my $ua   = $app->new_ua;
    my $blog = $app->model('blog')->load( $obj->blog_id );
    my @hooks
        = $app->model('webhook')
        ->load(
        { blog_id => $blog->id, hook => 'post_save_' . $obj->class } );

    for my $h (@hooks) {
        require MT::Template::Context;
        my $ctx = MT::Template::Context->new;
        $ctx->stash( 'blog', $blog );
        local $ctx->{__stash}{entry} = $obj;

        require MT::Builder;
        my $build = MT::Builder->new;

        my $headers
            = _build_and_encode_hash( $ctx, $build, $h->headers || {} );
        my $body = _build_and_encode_hash( $ctx, $build, $h->body || {} );

        my $new_headers = {};
        for my $key ( keys %$new_headers ) {
            $new_headers->{":${key}"} = $headers->{$key};
        }
        $headers = $new_headers;

        my $method = lc $h->method;
        my $res = $ua->$method( $h->url, %$headers, Content => $body );
    }

    1;
}

sub _build_and_encode_hash {
    my ( $ctx, $build, $hash ) = @_;
    my $new_hash = {};
    for my $key ( keys %$hash ) {
        my $new_key   = _build_and_encode( $ctx, $build, $key );
        my $new_value = _build_and_encode( $ctx, $build, $hash->{$key} );
        next if !defined $new_key || !defined $new_value;
        $new_hash->{$new_key} = $new_value;
    }
    return $new_hash;
}

sub _build_and_encode {
    my ( $ctx, $build, $string ) = @_;
    my $tokens = $build->compile( $ctx, $string );
    my $out = $build->build( $ctx, $tokens );
    require Encode;
    $out = Encode::encode_utf8($out) if Encode::is_utf8($out);
    return $out;
}

1;
