# Movable Type (r) (C) 2006-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleAnalytics::App;

use strict;
use warnings;

use Encode;
use MT::Util;

use GoogleAnalytics;
use GoogleAnalytics::OAuth2;

sub _is_effective_plugindata {
    my ( $app, $plugindata, $client_id ) = @_;

    my $result = $plugindata
        && ( !$client_id
        || $plugindata->data->{token_data}{client_id} eq $client_id )
        && effective_token( $app, $plugindata );
    $app->error(undef);

    $result;
}

sub _get_session_token_data_key {
    my ($app) = @_;
    my $blog = $app->blog;
    'ga_token_data_' . ( $blog ? $blog->id : 'system' );
}

sub _get_session_token_data {
    my ($app) = @_;
    $app->session->get( _get_session_token_data_key(@_) );
}

sub _set_session_token_data {
    my ( $app, $data ) = @_;
    $app->session->set( _get_session_token_data_key(@_), $data );
}

sub _clear_session_token_data {
    my ($app) = @_;
    $app->session->set( _get_session_token_data_key(@_), undef );
}

sub _extract_blog_from_plugindata {
    my ( $app, $current_blog, $plugindata ) = @_;

    my @empty = ( undef, undef );
    return @empty unless $plugindata;

    my ($blog_id) = $plugindata->key =~ m/blog:(\d+)/;
    if ( !$blog_id || $blog_id != $current_blog->id ) {
        my $blog;

        if ($blog_id) {
            $blog = $app->model('blog')->load($blog_id);
        }
        else {
            $blog_id = '';
        }

        return $blog_id, $blog;
    }

    return @empty;
}

sub config_tmpl {
    my $app    = MT->instance;
    my $user   = $app->user;
    my $plugin = plugin();
    my $blog   = $app->blog;
    my $scope  = $blog ? ( 'blog:' . $blog->id ) : 'system';
    my $config = $plugin->get_config_hash($scope);
    my $configured
        = _is_effective_plugindata( $app, $plugin->get_config_obj($scope) );
    my $current = GoogleAnalytics::current_plugindata_hash( $app, $blog );
    my ($parent_client_blog_id,  $parent_client_blog,
        $parent_profile_blog_id, $parent_profile_blog,
        $parent_profile,         $has_parent_client_permission
    );

    if ($blog) {
        if ( !$configured ) {
            ( $parent_client_blog_id, $parent_client_blog )
                = _extract_blog_from_plugindata( $app, $blog,
                $current->{client} );

            ( $parent_profile_blog_id, $parent_profile_blog )
                = _extract_blog_from_plugindata( $app, $blog,
                $current->{profile} );

            if ( defined $parent_profile_blog_id ) {
                $parent_profile = $current->{profile};
                delete @$config{
                    qw(profile_name profile_web_property_id profile_id)};
            }
            elsif ($blog) {
                my $parent = GoogleAnalytics::current_plugindata_hash( $app,
                    $blog->is_blog ? $blog->website : undef );
                ( $parent_profile_blog_id, $parent_profile_blog )
                    = _extract_blog_from_plugindata( $app, $blog,
                    $parent->{profile} );

                if ( defined $parent_profile_blog_id ) {
                    if ($parent_client_blog_id != $parent_profile_blog_id
                        && (access_token_id( $current->{client}->data ) ne (
                                $parent->{profile}->data->{access_token_id}
                                    || ''
                            )
                        )
                        )
                    {
                        undef $parent_profile_blog_id;
                        undef $parent_profile_blog;
                    }
                    else {
                        $parent_profile = $parent->{profile};
                    }
                }
            }
        }

        if ($parent_client_blog_id) {
            $has_parent_client_permission
                = $user->blog_perm($parent_client_blog_id)
                ->can_do('edit_config');
        }
        else {
            $has_parent_client_permission = $user->can_do('edit_config');
        }

        if ( !$config->{client_id} && !defined($parent_client_blog_id) ) {
            delete @$config{
                qw(profile_name profile_web_property_id profile_id)};
        }
    }

    my $missing = undef;
    $missing = $app->translate( 'missing required Perl modules: [_1]',
        'Crypt::SSLeay' )
        unless eval { require IO::Socket::SSL }
        || eval     { require Crypt::SSLeay };

    $plugin->load_tmpl(
        'web_service_config.tmpl',
        {   missing_modules => $missing,
            authorize_url =>
                authorize_url( $app, '__client_id__', '__redirect_uri__' ),
            ( map { ( "ga_$_" => $config->{$_} || '' ) } keys(%$config) ),
            dialog_url => $app->uri(
                mode => 'ga_select_profile',
                ( $blog ? ( args => { blog_id => $app->blog->id, } ) : () ),
            ),
            redirect_uri => $app->uri( mode => 'ga_oauth2callback' ),
            (   !$config->{client_id}
                ? ( parent_client         => defined($parent_client_blog_id),
                    parent_client_blog_id => $parent_client_blog_id,
                    parent_client_blog_name => $parent_client_blog
                    ? $parent_client_blog->name
                    : '',
                    has_parent_client_permission =>
                        $has_parent_client_permission,
                    )
                : ()
            ),
            (   $parent_profile
                ? ( parent_profile_blog_id   => $parent_profile_blog_id,
                    parent_profile_blog_name => $parent_profile_blog
                    ? $parent_profile_blog->name
                    : '',
                    parent_profile_name =>
                        $parent_profile->data->{profile_name},
                    parent_profile_web_property_id =>
                        $parent_profile->data->{profile_web_property_id},
                    )
                : ()
            ),
            (   $configured
                ? ( configured_client_id     => $config->{client_id},
                    configured_client_secret => $config->{client_secret},
                    )
                : ()
            ),
        }
    )->build;
}

sub save_config {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $plugin = plugin();

    my $scope = $obj ? ( 'blog:' . $obj->id ) : 'system';
    my $config = $plugin->get_config_hash($scope);

    my $old_client_id  = $config->{client_id}  || '';
    my $old_profile_id = $config->{profile_id} || '';

    for my $k (
        qw(
        client_id client_secret
        profile_name profile_web_property_id profile_id
        )
        )
    {
        $config->{$k} = $app->param( 'ga_' . $k );
    }

    my $token = _get_session_token_data($app);
    if (   $token
        && $token->{client_id} eq $config->{client_id} )
    {
        $config->{token_data} = $token;
    }

    my $current = GoogleAnalytics::current_plugindata_hash( $app, $obj );
    if (   $obj
        && $config->{profile_id}
        && !$config->{client_id}
        && $current->{client} )
    {
        $config->{parent_access_token_id}
            = access_token_id( $current->{client}->data );
    }
    else {
        delete $config->{parent_access_token_id};
    }

    if ( !$config->{client_id} ) {
        delete $config->{token_data};
        if ( !$config->{parent_access_token_id} ) {
            delete @$config{
                qw(profile_name profile_web_property_id profile_id)};
        }
    }

    if ( !$config->{profile_id} ) {
        delete $config->{parent_access_token_id};
    }

    $plugin->save_config( $config, $scope );

    _clear_session_token_data($app);

    # Clear cache for site stats dashnoard widget.
    if (   $old_client_id ne $config->{client_id}
        || $old_profile_id ne $config->{profile_id} )
    {
        my @site_ids = ( $obj ? $obj->id : 0 );
        if ( $obj && !$obj->is_blog ) {
            foreach my $blog ( @{ $obj->blogs } ) {
                push @site_ids, $blog->id;
            }
        }
        require MT::Util;
        foreach my $site_id (@site_ids) {
            MT::Util::clear_site_stats_widget_cache( $site_id,
                $app->user->id )
                or return $app->error(
                translate('Removing stats cache was failed.') );
        }
    }

    1;
}

sub _render_api_error {
    my ( $app, $params ) = @_;
    $params ||= {};

    plugin()->load_tmpl( 'api_error.tmpl', $params );
}

sub select_profile {
    my $app = shift;

    my $blog = $app->blog;
    my $ua   = new_ua();
    my $token_data;
    my $client_id = $app->param('client_id');
    my $retry     = 0;

    if ( !$client_id ) {
        return unless $blog;
        my $current = GoogleAnalytics::current_plugindata_hash( $app, $blog );
        if ( $current->{client} ) {
            if ( _is_effective_plugindata( $app, $current->{client} ) ) {
                $token_data = effective_token( $app, $current->{client} );
            }
        }

        return $app->error( translate('You did not specify a client ID.') )
            unless $token_data;
    }
    elsif ( my $client_secret = $app->param('client_secret') ) {
        $app->validate_magic or return;

        my $code = $app->param('code')
            or return $app->error( translate('You did not specify a code.') );

        $token_data
            = get_token( $app, $ua, $client_id, $client_secret,
            scalar $app->param('redirect_uri'), $code )
            or return _render_api_error( $app, { error => $app->errstr } );

        _set_session_token_data( $app, $token_data );
    }
    else {
        $token_data = _get_session_token_data($app);
        if ( !$token_data || $token_data->{client_id} ne $client_id ) {
            my $plugindata
                = plugin()
                ->get_config_obj(
                $blog ? ( 'blog:' . $blog->id ) : 'system' );
            if ( _is_effective_plugindata( $app, $plugindata, $client_id ) ) {
                $token_data = effective_token( $app, $plugindata );
            }
        }

        return _render_api_error( $app, { retry => 1 } )
            unless $token_data;

        $retry = 1;
    }

    my $list = get_profiles( $app, $ua, $token_data )
        or return _render_api_error( $app,
        { error => $app->errstr, retry => $retry } );

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
                ( $blog ? ( args => { blog_id => $blog->id, } ) : () ),
            ),
        }
    );
}

sub select_profile_complete {
    my $app = shift;

    plugin()->load_tmpl('select_profile_complete.tmpl');
}

sub oauth2callback {
    my $app = shift;

    my $params = { code => scalar $app->param('code'), };

    plugin()->load_tmpl( 'oauth2callback.tmpl', $params );
}

1;
