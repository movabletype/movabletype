<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcommentid($args, &$ctx) {
    $comment = $ctx->stash('comment');
    $id = $comment->comment_id;
    if (isset($args['pad']) && $args['pad']) {
        $id = sprintf("%06d", $id);
    }
    return $id;
}
?>
