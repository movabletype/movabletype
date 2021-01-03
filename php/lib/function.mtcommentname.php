<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
