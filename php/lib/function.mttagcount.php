<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
