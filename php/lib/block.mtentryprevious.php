<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtentryprevious($args, $content, &$ctx, &$repeat) {
    static $_prev_cache = array();
    if (!isset($content)) {
        $ctx->localize(array('entry', 'conditional', 'else_content'));
        $entry = $ctx->stash('entry');
        if ($entry) {
            $entry_id = $entry->entry_id;
            if (isset($_prev_cache[$entry_id])) {
                $prev_entry = $_prev_cache[$entry_id];
            } else {
                $mt = MT::get_instance();
                $ts = $mt->db()->db2ts($entry->entry_authored_on);
                $blog_id = $entry->entry_blog_id;
                if (isset($args['class'])) {
                    $class = $args['class'];
                } else {
                    $class = 'entry';
                }
                $args = array('not_entry_id' => $entry_id,
                              'current_timestamp_end' => $ts,
                              'lastn' => 1,
                              'blog_id' => $blog_id,
                              'class' => $class);
                list($prev_entry) = $ctx->mt->db()->fetch_entries($args);
                if ($prev_entry) $_prev_cache[$entry_id] = $prev_entry;
            }
            $ctx->stash('entry', $prev_entry);
        }
        $ctx->stash('conditional', isset($prev_entry));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('entry', 'conditional', 'else_content'));
    }
    return $content;
}
?>
