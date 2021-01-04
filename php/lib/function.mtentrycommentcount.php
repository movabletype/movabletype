<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrycommentcount($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (isset($args['top']) and $args['top'] == 1) {
        $where = "(comment_parent_id is NULL
           or comment_parent_id = 0)
           and comment_visible = 1 
           and comment_entry_id = ".$entry->entry_id;
        require_once('class.mt_comment.php');
        $comment = new Comment;
        $count = $comment->count(array('where' => $where));
    }
    else {
        $count = $entry->entry_comment_count;
    }
    return $ctx->count_format($count, $args);
}
?>
