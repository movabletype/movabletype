# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Comment;

use warnings;
use strict;

use MT::Util qw(remove_html);
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;
use MT::CMS::Comment;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'comment' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_entry {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        $entry->class, $entry->id, obj_promise($entry) )
        or return;

    my $res = filtered_list( $app, $endpoint, 'comment',
        { entry_id => $entry->id } );

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub _build_default_comment {
    my ( $app, $endpoint, $blog, $entry ) = @_;

    my $nick = $app->user->nickname || $app->translate('Registered User');
    my $orig_comment = $app->model('comment')->new;
    $orig_comment->set_values(
        {   ip           => $app->remote_ip,
            blog_id      => $blog->id,
            entry_id     => $entry->id,
            commenter_id => $app->user->id,
            author       => remove_html($nick),
            email        => remove_html( $app->user->email ),
        }
    );

    if ( $blog->publish_trusted_commenters ) {
        $orig_comment->approve;
    }
    else {
        $orig_comment->moderate;
    }

    $orig_comment;
}

sub _publish_and_send_notification {
    my ( $app, $blog, $entry, $comment ) = @_;

    MT::Util::start_background_task(
        sub {
            $app->rebuild_entry(
                Entry             => $entry->id,
                BuildDependencies => 1
                )
                or return $app->publish_error( "Publishing failed. [_1]",
                $app->errstr );
        }
    );
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    my $orig_comment
        = _build_default_comment( $app, $endpoint, $blog, $entry );

    my $new_comment = $app->resource_object( 'comment', $orig_comment )
        or return;

    save_object( $app, 'comment', $new_comment )
        or return;

    $app->_send_comment_notification( $new_comment, q(), $entry,
        $blog, $app->user );

    $new_comment;
}

sub create_reply {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry, $parent ) = context_objects(@_)
        or return;

    MT::CMS::Comment::can_do_reply( $app, $entry )
        or return $app->error(403);

    my $orig_comment
        = _build_default_comment( $app, $endpoint, $blog, $entry );
    $orig_comment->set_values( { parent_id => $parent->id, } );

    my $new_comment = $app->resource_object( 'comment', $orig_comment )
        or return;

    save_object( $app, 'comment', $new_comment )
        or return;

    $app->_send_comment_notification( $new_comment, q(), $entry,
        $blog, $app->user );

    $new_comment;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $comment ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'comment', $comment->id, obj_promise($comment) )
        or return;

    $comment;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $comment ) = context_objects(@_)
        or return;
    my $new_comment = $app->resource_object( 'comment', $comment )
        or return;

    save_object( $app, 'comment', $new_comment, $comment )
        or return;

    $new_comment;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $comment ) = context_objects(@_)
        or return;

    remove_object( $app, 'comment', $comment )
        or return;

    $comment;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Comment - Movable Type class for endpoint definitions about the MT::Comment.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
