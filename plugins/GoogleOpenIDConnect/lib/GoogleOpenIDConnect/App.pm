# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleOpenIDConnect::App;

use strict;
use warnings;

use Encode;
use MT::Util;

use GoogleOpenIDConnect;
use GoogleOpenIDConnect::OIDC;

sub _key {
    return 'GoogleOpenIDConnect';
}

sub config_tmpl {
    my $app           = MT->instance;
    my $user          = $app->user;
    my $plugin        = plugin();
    my $blog          = $app->blog;
    my $scope         = $blog ? ( 'blog:' . $blog->id ) : 'system';
    my $config        = $plugin->get_config_hash($scope);
    my $system_config = $plugin->get_config_hash('system');
    $app->param( 'key', _key() );

    my $missing = undef;
    $missing = $app->translate(
        'A Perl module required for using Google Open ID Connect is missing: [_1].',
        'OIDC::Lite'
        )
        unless eval { require OIDC::Lite::Client::WebServer }
        || eval     { require OIDC::Lite::Model::IDToken };

    my $current_client = '';
    if ( $config->{client_id} && $config->{client_secret} ) {
        $current_client = 'blog';
    }
    elsif ( $system_config->{client_id} && $system_config->{client_secret} ) {
        $current_client = 'system';
    }

    $plugin->load_tmpl(
        'web_service_config.tmpl',
        {   missing_modules => $missing,
            current_client  => $current_client,
            (   map { ( "google_oidc_$_" => $config->{$_} || '' ) }
                    keys(%$config)
            ),
            (   map {
                    ( "google_oidc_system_$_" => $system_config->{$_} || '' )
                    }
                    keys(%$system_config)
            ),
            redirect_uri => MT::Auth::OIDC::_create_return_url( $app, $blog ),
            (   $blog
                ? ( scope_label => $blog->class_label, )
                : ()
            ),
            'plugin_path' => $plugin->path
        }
    )->build;
}

sub save_config {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $plugin = plugin();

    my $scope = $obj ? ( 'blog:' . $obj->id ) : 'system';
    my $config = $plugin->get_config_hash($scope);

    for my $k (qw(client_id client_secret)) {
        $config->{$k} = $app->param( 'google_oidc_' . $k );
    }
    $plugin->save_config( $config, $scope );

}

1;
