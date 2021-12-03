<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentryprevious($args, $content, &$ctx, &$repeat) {
    static $_prev_cache = array();
    if (!isset($content)) {
        $ctx->localize(array('entry', 'conditional', 'else_content'));
        $entry = $ctx->stash('entry');
        if ($entry) {
            $label = $entry->entry_id;
            if (isset($args['by_author']) && $args['by_author']) {
                $label .= ':author=' . $entry->entry_author_id;
            }
            if ((isset($args['by_category']) && $args['by_category']) || (isset($args['by_folder']) && $args['by_folder'])) {
                $cat = $entry->category();
                $cat_id = $cat ? $cat->category_id : 0;
                $label .= ':category=' . $cat_id;
            }

            if (isset($_prev_cache[$label])) {
                $prev_entry = $_prev_cache[$label];
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
                $eargs = array('not_entry_id' => $entry->entry_id,
                              'current_timestamp_end' => $ts,
                              'lastn' => 1,
                              'blog_id' => $blog_id,
                              'class' => $class);
                if (isset($args['by_author'])) {
                    $eargs['author_id'] = $entry->entry_author_id;
                }
                if (isset($args['by_category']) || isset($args['by_folder'])) {
                    $eargs['category_id'] = $cat_id;
                }
                $entries = $ctx->mt->db()->fetch_entries($eargs);
                $prev_entry = isset($entries[0]) ? $entries[0] : null;
                if ($prev_entry) $_prev_cache[$label] = $prev_entry;
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
