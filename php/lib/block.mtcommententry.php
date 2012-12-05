<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcommententry($args, $content, &$ctx, &$repeat) {
    $localvars = array('entry', 'current_timestamp', 'modification_timestamp');
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        if (!$comment) { $repeat = false; return ''; }
        $entry_id = $comment->comment_entry_id;
        $method = 'fetch_entry';
        $entry = $comment->entry();
        if ($entry->class != 'entry') {
            $method = 'fetch_' . $entry->class;
            $entry = $ctx->mt->db()->$method($entry_id);
        }
        if (!$entry) { $repeat = false; return ''; }
        $ctx->localize($localvars);
        $ctx->stash('entry', $entry);
        $ctx->stash('current_timestamp', $entry->entry_authored_on);
        $ctx->stash('modification_timestamp', $entry->entry_modified_on);
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}
?>
