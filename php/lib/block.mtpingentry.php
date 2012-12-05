<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
