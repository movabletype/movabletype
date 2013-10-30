<?php
# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentrynext($args, $content, &$ctx, &$repeat) {
    static $_next_cache = array();
    if (!isset($content)) {
        # save all values, to be restored when we're done...
        $ctx->localize(array('entry', 'conditional', 'else_content'));
        $entry = $ctx->stash('entry');
        if ($entry) {
            $entry_id = $entry->entry_id;
            if (isset($_next_cache[$entry_id])) {
                $next_entry = $_next_cache[$entry_id];
            } else {
                $mt = MT::get_instance();
                $blog_id = $entry->entry_blog_id;
                if (isset($args['class'])) {
                    $class = $args['class'];
                } else {
                    $class = 'entry';
                }
                $ts = $mt->db()->db2ts( ($class == 'entry')
                    ? $entry->entry_authored_on
                    : $entry->entry_modified_on
                );
                $args = array('not_entry_id' => $entry->entry_id,
                              'blog_id' => $blog_id,
                              'lastn' => 1,
                              'base_sort_order' => 'ascend',
                              'current_timestamp' => $ts,
                              'class' => $class);
                list($next_entry) = $ctx->mt->db()->fetch_entries($args);
                if ($next_entry) $_next_cache[$entry_id] = $next_entry;
            }
            $ctx->stash('entry', $next_entry);
        }
        $ctx->stash('conditional', isset($next_entry));
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
