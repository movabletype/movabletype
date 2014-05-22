<?php
# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifcommenterisentryauthor($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $cmtr = $ctx->stash('commenter');
        $comment = $ctx->stash('comment');
        if (isset($comment)) {
            $entry_id = $comment->comment_entry_id;
            $entry = $comment->entry();
            if ($entry->class != 'entry') {
                $method = 'fetch_entry';
                $entry_class = $comment->entry_class;
                if (isset($entry_class)) {
                    $method = 'fetch_' . $entry_class;
                }
                $entry = $ctx->mt->db()->$method($entry_id);
            }
        }
        if (!isset($entry)) {
            $entry = $ctx->stash('entry');
        }
        if (!isset($cmtr) || !isset($entry)) {
            return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
        }
        $is_entryauthor =
            $cmtr->author_type == 1
          ? $cmtr->author_id == $entry->entry_author_id ? 1 : 0
          : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $is_entryauthor);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
