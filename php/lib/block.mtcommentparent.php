<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcommentparent($args, $content, &$ctx, &$repeat) {
    $localvars = array('comment', 'commenter', 'current_timestamp');
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        if (!$comment) { $repeat = false; return '';}
        $args['parent_id'] = $comment->comment_parent_id;
        $parent = $ctx->mt->db()->fetch_comment_parent($args);
        if (!$parent) { $repeat = false; return ''; }
        $ctx->localize($localvars);
        $parent_comment = $parent;
        $ctx->stash('comment', $parent_comment);
        $ctx->stash('current_timestamp', $parent_comment->comment_created_on);
        if ($parent_comment->comment_commenter_id) {
            $commenter = $parent_comment->commenter();
            if (empty($commenter)) {
                $ctx->__stash['commenter'] = null;
            } else {
                $ctx->stash('commenter', $commenter);
            }
        } else {
            $ctx->__stash['commenter'] = null;
        }
        $counter = 0;
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}
?>
