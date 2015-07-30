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

sub _is_effective_plugindata {
    my ( $app, $plugindata, $client_id ) = @_;

    my $result
        = $plugindata
        && $plugindata->data->{client_id};
    $app->error(undef);

    $result;
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
    my $current = GoogleOpenIDConnect::current_plugindata_hash( $app, $blog );
    my ($parent_client_blog_id, $parent_client_blog,
        $parent_client,         $parent_profile_blog_id,
        $parent_profile_blog,   $parent_profile,
        $has_parent_client_permission
    );

    if ($blog) {
        if ( !$configured ) {
            ( $parent_client_blog_id, $parent_client_blog )
                = _extract_blog_from_plugindata( $app, $blog,
                $current->{client} );
            if ( defined $parent_client_blog_id ) {
                $parent_client = $current->{client};
            }
            if ($blog) {
                my $parent
                    = GoogleOpenIDConnect::current_plugindata_hash( $app,
                    $blog->is_blog ? $blog->website : undef );
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

    }

    $plugin->load_tmpl(
        'web_service_config.tmpl',
        {
            ( map { ( "google_oidc_$_" => $config->{$_} || '' ) } keys(%$config) ),
            (   !$config->{client_id}
                ? ( parent_client    => defined($parent_client_blog_id),
                    parent_client_id => $parent_client
                    ? $parent_client->data->{client_id}
                    : '',
                    parent_client_blog_id   => $parent_client_blog_id,
                    parent_client_blog_name => $parent_client_blog
                    ? $parent_client_blog->name
                    : '',
                    has_parent_client_permission =>
                        $has_parent_client_permission,
                    )
                : ()
            ),
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

    my $old_client_id  = $config->{client_id}  || '';
    my $old_profile_id = $config->{profile_id} || '';

    for my $k (qw(client_id client_secret)) {
        $config->{$k} = $app->param( 'google_oidc_' . $k );
    }

    my $current = GoogleOpenIDConnect::current_plugindata_hash( $app, $obj );
    if (   $obj
        && $config->{profile_id}
        && !$config->{client_id}
        && $current->{client} )
    {
        my $current_data = $current->{client}->data;
        @$config{qw(parent_client_id parent_client_secret)}
            = @$current_data{qw(client_id client_secret)};
    }
    else {
        delete @$config{qw(parent_client_id parent_client_secret)};
    }

    $plugin->save_config( $config, $scope );

}

sub _render_api_error {
    my ( $app, $params ) = @_;
    $params ||= {};

    plugin()->load_tmpl( 'api_error.tmpl', $params );
}

1;
