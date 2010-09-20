# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::BanList;

use strict;

sub can_save {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('save_banlist');
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $ip    = $app->param('ip');
    $ip =~ s/(^\s+|\s+$)//g;
    return $eh->error(
        MT->translate("You did not enter an IP address to ban.") )
      if ( '' eq $ip );
    my $blog_id = $app->param('blog_id');
    require MT::IPBanList;
    my $existing =
      MT::IPBanList->load( { 'ip' => $ip, 'blog_id' => $blog_id } );
    my $id = $app->param('id');

    if ( $existing && ( !$id || $existing->id != $id ) ) {
        return $eh->error(
            $app->translate(
                "The IP you entered is already banned for this blog.")
        );
    }
    return 1;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    require MT::Permission;
    my $blog_ids = $load_options->{blog_ids} || undef;
    my $iter = MT::Permission->load_iter(
        {
            author_id => $user->id,
            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 }) ),
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
