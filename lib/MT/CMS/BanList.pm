# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::BanList;

use strict;
use warnings;

sub can_save {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('save_banlist');
}

sub can_delete {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('delete_banlist');
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $ip    = $app->param('ip');
    $ip =~ s/(^\s+|\s+$)//g;
    return $eh->error('empty') if ( '' eq $ip );
    my $blog_id = $app->param('blog_id');
    require MT::IPBanList;
    my $existing
        = MT::IPBanList->load( { 'ip' => $ip, 'blog_id' => $blog_id } );
    my $id = $app->param('id') || 0;

    if ( $existing && ( !$id || $existing->id != $id ) ) {
        return $eh->error('duplicated');
    }
    return 1;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    require MT::Permission;
    my $options_blog_ids = $load_options->{blog_ids};
    my $iter             = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $options_blog_ids
                ? ( blog_id => $options_blog_ids )
                : ( blog_id => { not => 0 } )
            ),
        },
    );

    my $blog_ids;
    while ( my $perm = $iter->() ) {
        push @$blog_ids, $perm->blog_id
            if $perm->can_do('access_to_banlist');
    }

    my $terms = $load_options->{terms};
    $terms->{blog_id} = $blog_ids
        if $blog_ids;
    $load_options->{terms} = $terms;
}

1;
