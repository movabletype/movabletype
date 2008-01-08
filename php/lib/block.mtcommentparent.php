<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcommentparent($args, $content, &$ctx, &$repeat) {
    $localvars = array('comment');
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        if (!$comment) { $repeat = false; return '';}
        $args['parent_id'] = $comment['comment_parent_id'];
        $parent = $ctx->mt->db->fetch_comment_parent($args);
        if (!$parent) { $repeat = false; return ''; }
        $ctx->localize($localvars);
        $ctx->stash('comment', $parent[0]);
        $counter = 0;
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}
?>
