<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtpingentry($args, $content, &$ctx, &$repeat) {
    $localvars = array('entry', 'current_timestamp', 'modification_timestamp');
    if (!isset($content)) {
        $ping = $ctx->stash('ping');
        if (!$ping) { $repeat = false; return ''; }
        $tb = $ping->trackback();
        $entry_id = $tb->trackback_entry_id;
        if (!$entry_id) { $repeat = false; return ''; }
        $entry = $tb->entry();
        if ($entry->class != 'entry') {
            $method = 'fetch_entry';
            $entry_class = $entry->entry_class;
            if (isset($entry_class)) {
                $method = 'fetch_' . $entry_class;
            }
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
