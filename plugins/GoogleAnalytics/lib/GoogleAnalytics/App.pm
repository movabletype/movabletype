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

sub blog_config_tmpl {
    my $app = MT->instance;

    plugin()->load_tmpl(
        'blog_config.tmpl',
        {   authorize_url => authorize_url( $app, '__client_id__' ),
            dialog_url    => $app->uri(
                mode => 'ga_input_code',
                args => { blog_id => $app->blog->id, },
            ),
        }
    );
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

    my $ua = $app->new_ua;

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
            ]
        }
    );
}

1;
