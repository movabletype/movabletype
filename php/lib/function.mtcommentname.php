<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentname($args, &$ctx) {
    $comment = $ctx->stash('comment');

    if ($comment->comment_commenter_id ) {
        $cmtr = $comment->commenter();
        if ( !empty( $cmtr ) )
            return $cmtr->nickname;
    }

    return $comment->comment_author;
}
?>
