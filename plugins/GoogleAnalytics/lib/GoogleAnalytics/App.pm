# Movable Type (r) Open Source (C) 2006-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package GoogleAnalytics::App;

use strict;
use warnings;

use Encode;
use MT::Util;

use GoogleAnalytics;
use GoogleAnalytics::OAuth2;

sub config_tmpl {
    my $app    = MT->instance;
    my $plugin = plugin();
    my $blog   = $app->blog
        or return;
    my $scope    = 'blog:' . $blog->id;
    my $config   = $plugin->get_config_hash($scope);
    my $defaults = $plugin->settings->defaults($scope);

    my $missing = undef;
    $missing = $app->translate( 'missing required Perl modules: [_1]',
        'Crypt::SSLeay' )
        unless eval { require IO::Socket::SSL }
        || eval     { require Crypt::SSLeay };

    $plugin->load_tmpl(
        'web_service_config.tmpl',
        {   missing_modules => $missing,
            authorize_url   => authorize_url( $app, '__client_id__' ),
            dialog_url      => $app->uri(
                mode => 'ga_input_code',
                args => { blog_id => $app->blog->id, },
            ),
            ( map { ( "ga_$_" => $config->{$_} || '' ) } keys(%$config) ),
            (   map { ( "default_$_" => $defaults->{$_} || '' ) }
                    keys(%$defaults)
            ),
        }
    )->build;
}

sub pre_save_blog {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $plugin = plugin();

    if (   !$app->param('overlay')
        && ( $app->param('cfg_screen') || '' ) eq 'cfg_web_services'
        && $app->can_do('edit_blog_config') )
    {
        my $scope  = 'blog:' . $obj->id;
        my $config = $plugin->get_config_hash($scope);

        for my $k (
            qw(
            client_id client_secret
            profile_name profile_web_property_id profile_id
            )
            )
        {
            $config->{$k} = $app->param( 'ga_' . $k );
        }

        if ( $config->{profile_id}
            && ( my $token = $app->session->get('ga_token_data') ) )
        {
            $config->{token_data} = $token;
        }
        elsif ( !$config->{profile_id} ) {
            delete $config->{token_data};
        }

        $plugin->save_config( $config, $scope );

        $app->session->set( 'ga_token_data', undef );
    }

    1;
}

sub _render_input_code {
    my ( $app, $params ) = @_;
    $params ||= {};

    $params->{client_id}     = $app->param('client_id');
    $params->{client_secret} = $app->param('client_secret');

    plugin()->load_tmpl( 'input_code.tmpl', $params );
}

sub _render_api_error {
    my ( $app, $params ) = @_;
    $params ||= {};

    plugin()->load_tmpl( 'api_error.tmpl', $params );
}

sub input_code {
    my $app = shift;
    _render_input_code($app);
}

sub select_profile {
    my $app  = shift;
    my $code = $app->param('code')
        or return _render_input_code( $app,
        { error => translate('You did not specify a code.'), } );

    my $ua = new_ua();

    my $token_data = get_token(
        $app, $ua,
        scalar $app->param('client_id'),
        scalar $app->param('client_secret'), $code
    ) or return _render_api_error( $app, { error => $app->errstr } );

    my $list = get_profiles( $app, $ua, $token_data )
        or return _render_api_error( $app, { error => $app->errstr } );

    plugin()->load_tmpl(
        'select_profile.tmpl',
        {   panel_label => translate('The name of the profile'),
            panel_description =>
                translate('The web property ID of the profile'),
            panel_type  => 'profile',
            panel_first => 1,
            panel_last  => 1,
            object_loop => [
                map {
                    +{  id          => $_->{id},
                        label       => $_->{name},
                        link        => $_->{websiteUrl},
                        description => $_->{webPropertyId},
                        }
                } @$list
            ],
            complete_url => $app->uri(
                mode => 'ga_select_profile_complete',
                args => { blog_id => $app->blog->id, },
            ),
        }
    );
}

sub select_profile_complete {
    my $app     = shift;
    my $session = $app->session;

    if ( my $token = $session->get('ga_token_data_tmp') ) {
        $session->set( 'ga_token_data',     $token );
        $session->set( 'ga_token_data_tmp', undef );
    }

    plugin()->load_tmpl('select_profile_complete.tmpl');
}

1;
