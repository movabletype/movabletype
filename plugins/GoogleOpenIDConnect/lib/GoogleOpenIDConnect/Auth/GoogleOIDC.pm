package GoogleOpenIDConnect::Auth::GoogleOIDC;

use strict;

use base qw( MT::Auth::OIDC );
use GoogleOpenIDConnect;
use JSON qw/encode_json decode_json/;
use MT::Util;

sub _login_form {
    my $class = shift;
    my $app   = shift;
    return $app->build_page('comment/auth_oidc.tmpl');
}

sub condition {
    my ( $blog, $reason ) = @_;
    return 1 unless $blog;

    my $plugin               = plugin();
    my $blog_id              = $blog->id;
    my $app                  = MT->instance;
    my $config_scope         = $blog_id ? ( 'blog:' . $blog_id ) : 'system';
    my $config               = get_plugindata($config_scope);
    my $google_client_id     = $config->{"client_id"};
    my $google_client_secret = $config->{"client_secret"};
    return 1 if ( $google_client_id && $google_client_secret );

    $$reason
        = '<a href="?__mode=cfg_web_services&amp;blog_id='
        . $blog->id . '">'
        . $plugin->translate('Set up Google OpenID Connect') . '</a>';

    return 0;
}

sub commenter_auth_params {
    my ( $key, $blog_id, $entry_id, $static ) = @_;
    require MT::Util;
    if ( $static =~ m/^https?%3A%2F%2F/ ) {
        $static = MT::Util::decode_url($static);
    }

    my $params = {
        blog_id => $blog_id,
        static  => $static,
    };
    $params->{entry_id} = $entry_id if defined $entry_id;
    return $params;
}

sub _get_client_info {
    my $class        = shift;
    my $app          = shift;
    my $blog         = shift;
    my $config_scope = $blog ? ( 'blog:' . $blog->id ) : 'system';
    my $plugin       = plugin();
    my $config       = get_plugindata($config_scope);

    my $info = undef;
    if ($config) {
        $info->{client_id}     = $config->{"client_id"};
        $info->{client_secret} = $config->{"client_secret"};
    }
    return $info;
}

1;
