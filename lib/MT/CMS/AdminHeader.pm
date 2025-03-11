# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::AdminHeader;
use strict;
use warnings;

sub fetch_admin_header_content_types {
    my ($app) = @_;

    $app->validate_magic()
        or return $app->error($app->json_error($app->translate("Invalid Request.")));

    my $blog_id = $app->param('blog_id');
    my $user    = $app->user;
    my @content_types;
    my $iter = MT->model('content_type')->load_iter({ blog_id => $blog_id || \'> 0' }, { sort => 'name' });

    while (my $ct = $iter->()) {
        my $perms                            = $user->permissions($ct->blog_id);
        my $user_can_create_new_content_data = $perms->can_do('create_new_content_data');
        my $user_can_manage_content_data =
               $user->is_superuser
            || $user->permissions(0)->can_do('manage_content_data')
            || $perms->can_do('manage_content_data');

        push @content_types,
            +{
            id         => $ct->id,
            name       => $ct->name,
            can_create => ($user_can_create_new_content_data || $perms->can_do("create_new_content_data_" . $ct->unique_id)) ? 1 : 0,
            can_search => ($user_can_manage_content_data     || $perms->can_do('search_content_data_' . $ct->unique_id))     ? 1 : 0,
            };
    }
    $app->json_result({ success => 1, content_types => \@content_types });
}

sub search_tabs_json {
    my ($app) = @_;

    require MT::CMS::Search;
    return $app->json_error( $app->translate('Permission denied') )
      unless MT::CMS::Search::can_search_replace($app);

    my $blog_id     = $app->param('blog_id');
    my $search_apis = $app->search_apis( $blog_id ? 'blog' : 'system' );
    my @search_tabs;
    foreach my $api (@$search_apis) {
        my $label = $api->{label};
        if ( ref $label eq 'CODE' ) {
            $label = $label->();
        }
        push @search_tabs,
          +{
            key   => $api->{key},
            label => $label,
          };
    }
    $app->json_result( { success => 1, data => \@search_tabs } );
}

1;
