# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Trackback;

use strict;
use warnings;

sub can_view {
    my $eh = shift;
    my ( $app, $id, $objp ) = @_;
    my $obj = $objp->force() or return 0;
    require MT::Trackback;
    my $tb    = MT::Trackback->load( $obj->tb_id );
    my $perms = $app->permissions
        or return 0;

    if ($tb) {
        my ( $entry, $cat );
        if ( $tb->entry_id ) {
            $entry = $app->model('entry')->load( $tb->entry_id );
        }
        elsif ( $tb->category_id ) {
            $cat = $app->model('category')->load( $tb->category_id );
        }

        if ( $obj->is_published ) {
            return 1
                if ( $entry && $entry->status == MT::Entry::RELEASE() )
                || $cat;
        }

        if ( $tb->entry_id ) {
            return (
                !$entry
                    || ( $entry->author_id == $app->user->id
                    && $app->can_do('open_own_entry_trackback_edit_screen') )
                    || $perms->can_do('open_all_trackback_edit_screen')
            );
        }
        elsif ( $tb->category_id ) {
            return $cat
                && $perms->can_do('open_category_trackback_edit_screen');
        }
    }
    else {
        return 0;    # no TrackBack center--no edit
    }
    return 1;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    my $terms = $load_options->{terms} ||= {};
    my $blog_ids = delete $terms->{blog_id}
        if exists $terms->{blog_id};

    my %filters = ();
    for my $id ( ref $blog_ids ? @$blog_ids : $blog_ids ) {
        $filters{ $id || 0 } = {
            ( $id ? ( blog_id => $id ) : () ),
            '!tbping_visible!'     => 1,
            '!tbping_junk_status!' => MT::TBPing::NOT_JUNK(),
        };
    }

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $blog_ids
                ? ( blog_id => $blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    my $args = $load_options->{args};
    while ( my $perm = $iter->() ) {
        my $blog_id = $perm->blog_id;
        if (   $perm->can_do('manage_feedback')
            || $perm->can_do('manage_pages') )
        {
            $filters{$blog_id} = { blog_id => $blog_id, };
        }
        elsif ( $perm->can_do('create_post') ) {
            $filters{$blog_id} = [
                { blog_id => $blog_id, author_id => $user->id },
                '-or',
                {   blog_id                => $blog_id,
                    '!tbping_visible!'     => 1,
                    '!tbping_junk_status!' => MT::Comment::NOT_JUNK(),
                }
            ];
        }
    }

    $args->{joins} ||= [];
    push @{ $args->{joins} },
        MT->model('entry')->join_on(
        undef,
        [   { id => \'=trackback_entry_id', },
            '-and',
            [ map { ( '-or', $_ ) } values %filters ],
        ],
        );
    push @{ $args->{joins} },
        MT->model('trackback')
        ->join_on( undef, [ { id => \'=tbping_tb_id', }, ], );
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Trackback - Movable Type class for Data API's callbacks about the MT::TBPing.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
