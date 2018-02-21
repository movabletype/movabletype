# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Comment;

use strict;
use warnings;

sub can_view {
    my $eh = shift;
    my ( $app, $id, $objp ) = @_;
    return 0 unless ($id);
    my $obj = $objp->force() or return 0;
    require MT::Entry;
    my $entry = MT::Entry->load( $obj->entry_id )
        or return 0;

    return 1 if $entry->status == MT::Entry::RELEASE() && $obj->is_published;

    if ( $entry->author_id == $app->user->id ) {
        return $app->can_do('open_own_entry_comment_edit_screen');
    }
    else {
        return $app->can_do('open_comment_edit_screen');
    }
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
            '!comment_visible!'     => 1,
            '!comment_junk_status!' => MT::Comment::NOT_JUNK(),
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
        if ( $perm->can_do('view_all_comments') ) {
            $filters{$blog_id} = { blog_id => $blog_id, };
        }
        elsif ( $perm->can_do('view_own_entry_comment') ) {
            $filters{$blog_id} = [
                { blog_id => $blog_id, author_id => $user->id },
                '-or',
                {   blog_id                 => $blog_id,
                    '!comment_visible!'     => 1,
                    '!comment_junk_status!' => MT::Comment::NOT_JUNK(),
                }
            ];
        }
    }

    if (%filters) {
        $args->{joins} ||= [];
        push @{ $args->{joins} },
            MT->model('entry')->join_on(
            undef,
            [   { id => \'=comment_entry_id', },
                '-and',
                [ map { ( '-or', $_ ) } values %filters ],
            ],
            );
    }
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Comment - Movable Type class for Data API's callbacks about the MT::Comment.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
