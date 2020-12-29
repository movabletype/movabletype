<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mttagcount($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    $count = 0;
    if ($tag && is_object($tag)) {
        $count = $tag->tag_count;
        if($count == ''){
            $count = $ctx->mt->db()->tags_entry_count($tag->tag_id, $ctx->stash('class_type'));
        }
     }
    return $ctx->count_format($count, $args);
}
?>
