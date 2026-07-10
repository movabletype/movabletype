# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::BanList;

use strict;
use warnings;

sub can_save {
    my ($eh, $app, $obj) = @_;

    # no system scope
    my $blog_id = $app->param('blog_id') or return;
    if ($obj && !ref $obj) {
        $obj = MT->model('ipbanlist')->load($obj) or return;
    }
    return if $obj && $obj->blog_id != $blog_id;
    return $app->can_do('save_banlist');
}

sub can_delete {
    my ($eh, $app, $obj) = @_;
    my $user = $app->user or return;
    return 1 if $user->is_superuser;

    # no system scope for non-superuser
    my $blog_id = $app->param('blog_id') or return;

    # return if the user is not allowed to visit the page
    return unless $user->permissions($blog_id)->can_do('delete_banlist');

    if ($obj && !ref $obj) {
        $obj = MT->model('ipbanlist')->load($obj) or return;
    }
    return 1 if $obj->blog_id == $blog_id;

    my $site     = MT->model('website')->load($blog_id);
    my %blog_ids = map {$_->id => 1} $site->is_blog ? ($site) : ($site, @{ $site->blogs || [] });

    # at least the site is one of the children
    return if $obj && !$blog_ids{ $obj->blog_id };

    # make sure if the user has a perm for the target
    return $user->permissions($obj->blog_id)->can_do('delete_banlist');
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;

    # Saving banlist from the system scope list is not supported.
    my $blog_id = $app->param('blog_id') or return $eh->error('Invalid request');

    # Updating banlist is not supported.
    my $id = $app->param('id');
    return $eh->error('Invalid request') if $id;

    my $ip = $app->param('ip');
    $ip =~ s/(^\s+|\s+$)//g;
    return $eh->error('empty') if ( '' eq $ip );

    require MT::IPBanList;
    if (MT::IPBanList->exist({ 'ip' => $ip, 'blog_id' => $blog_id })) {
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
