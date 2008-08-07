<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifcommentparent($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        $has_parent = 0;
        if ($comment && $comment['comment_parent_id']) {
            $parent = $ctx->mt->db->fetch_comment_parent(array( 'parent_id' => $comment['comment_parent_id'], 'blog_id' => $comment['comment_blog_id']));
            $has_parent = $parent ? 1 : 0;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_parent);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
