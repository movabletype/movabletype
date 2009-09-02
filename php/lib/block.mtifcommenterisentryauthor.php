<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtifcommenterisentryauthor.php 106007 2009-07-01 11:33:43Z ytakayama $

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
