# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Core Summary Object Framework functions for MT::Author

package MT::Summary::Author;

use strict;
use warnings;
use MT::Author;
use MT::Entry;

sub summarize_comment_count {
    my $author = shift;
    my ($terms) = @_;
    my %args;
    use MT::Comment;
    $args{join} = MT::Entry->join_on(
        undef,
        {   id     => \'= comment_entry_id',
            status => MT::Entry::RELEASE(),
        }
    );
    my $comment_count = MT::Comment->count(
        {   commenter_id => $author->id,
            visible      => 1,
        },
        \%args
    );
    return $comment_count;
}

sub expire_comment_count {
    my ( $parent_obj, $obj, $terms ) = @_;

    # action: save/remove
    # parent_obj => author, obj => the comment
    return unless ( $parent_obj and $parent_obj->id );
    $parent_obj->set_summary( $terms, 0 );
    $parent_obj->expire_summary($terms);
}

sub expire_comment_count_entry {
    my ( $parent_obj, $obj, $terms, $action, $orig ) = @_;
    use MT::Comment;
    if ( $action eq 'remove' ) {
        my $c_iter = MT::Comment->load_iter( { entry_id => $obj->id } );
        while ( my $c = $c_iter->() ) {
            if ( $c->commenter_id ) {
                my $a = MT::Author->load( $c->commenter_id );
                $a->expire_summary('comment_count');
                if ( !$a->summary_is_expired('comment_count') ) {
                    $a->set_summary( $terms, 0 );
                    $a->expire_summary('comment_count');
                }
            }
        }
    }
    elsif ( $action eq 'save' ) {
        if ( $obj->{changed_cols}->{status} ) {
            my $c_iter = MT::Comment->load_iter( { entry_id => $obj->id } );
            while ( my $c = $c_iter->() ) {
                if ( $c->commenter_id ) {
                    my $a = MT::Author->load( $c->commenter_id );
                    $a->expire_summary('comment_count');
                    if ( !$a->summary_is_expired('comment_count') ) {
                        $a->set_summary( $terms, 0 );
                        $a->expire_summary('comment_count');
                    }
                }
            }
        }
    }
}

sub summarize_entry_count {
    my $author = shift;
    my ($terms) = @_;

    return MT->model('entry')->count(
        {   author_id => $author->id,
            status    => MT::Entry::RELEASE(),
        },
    );
}

sub expire_entry_count {
    my ( $parent_obj, $obj, $terms, $action, $orig ) = @_;

    # action: save/remove
    # parent_obj => author, obj => the entry
    my $count = $parent_obj->summary($terms);
    if ( !defined $count || $count < 1 && $action eq 'remove' ) {
        $parent_obj->expire_summary($terms);
    }
    elsif ( $action eq 'remove' ) {
        if ( $obj->status == MT::Entry::RELEASE()
            and !$parent_obj->summary_is_expired($terms) )
        {
            $parent_obj->set_summary( $terms, $count - 1 );
        }
    }
    elsif ( $action eq 'save' ) {
        if ( $obj->{changed_cols}->{status}
            && ( ( $orig->{__orig_value}->{status} || 0 ) != $obj->status ) )
        {
            if ( ( $obj->status || 0 ) == MT::Entry::RELEASE()
                && !$parent_obj->summary_is_expired($terms) )
            {
                $parent_obj->set_summary( $terms, $count + 1 );
            }
            elsif ( ( $orig->{__orig_value}->{status} || 0 )
                == MT::Entry::RELEASE() )
            {
                my $orig_author;
                if ( $orig->{__orig_value}->{author_id} ) {
                    $orig_author = MT::Author->load(
                        $orig->{__orig_value}->{author_id} );
                }
                else {
                    $orig_author = $parent_obj;
                }
                if ( $orig_author
                    and !$orig_author->summary_is_expired($terms) )
                {
                    my $orig_count = $orig_author->summary($terms);
                    if ( !defined $orig_count || $orig_count < 1 ) {
                        $orig_author->expire_summary($terms);
                    }
                    else {
                        $orig_author->set_summary( $terms, $orig_count - 1 );
                    }
                }
            }
        }
        if (    $obj->status == MT::Entry::RELEASE()
            and $obj->{changed_cols}->{author_id}
            and !$obj->{changed_cols}->{id}
            and $orig->{__orig_value}->{author_id} )
        {
            my $orig_author
                = MT::Author->load( $orig->{__orig_value}->{author_id} );
            if ( $orig_author and !$orig_author->summary_is_expired($terms) )
            {
                my $orig_count = $orig_author->summary($terms);
                if ( !defined $orig_count || $orig_count < 1 ) {
                    $orig_author->expire_summary($terms);
                }
                else {
                    $orig_author->set_summary( $terms, $orig_count - 1 );
                }
            }
            if ( !$parent_obj->summary_is_expired($terms) ) {
                $parent_obj->set_summary( $terms, $count + 1 );
            }
        }
    }
    else {
        die "Incorrect action type '$action'; expected save/remove\n";
    }
}

# ============= tags ===============

###########################################################################

=head2 AuthorEntriesCount

Returns number of entries written by the author who specified by current context.

=for tags authors entries

=cut

sub _hdlr_author_entries_count {
    my ( $ctx, $args, $cond ) = @_;
    my $author = $ctx->stash('author')
        or return $ctx->_no_author_error('MTAuthorEntryCount');

    return $ctx->count_format( $author->summarize('entry_count'), $args );
}

1;
