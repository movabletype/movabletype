<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtauthorprevious($args, $content, &$ctx, &$repeat) {
    static $_prev_cache = array();
    if (!isset($content)) {
        $ctx->localize(array('author', 'conditional', 'else_content'));
        $author = $ctx->stash('author');
        if ($author) {
            $author_id = $author['author_id'];
            if (isset($_prev_cache[$author_id])) {
                $prev_author = $_prev_cache[$author_id];
            } else {
                $name = $author['author_name'];
                $blog_id = $ctx->stash('blog_id');
                $args = array('sort_by' => 'author_name',
                              'sort_order' => 'descend',
                              'start_string' => $name,
                              'lastn' => 1,
                              'blog_id' => $blog_id,
                              'need_entry' => 1);
                list($prev_author) = $ctx->mt->db->fetch_authors($args);
                if ($prev_author) $_prev_cache[$author_id] = $prev_author;
            }
            $ctx->stash('author', $prev_author);
        }
        $ctx->stash('conditional', isset($prev_author));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('author', 'conditional', 'else_content'));
    }
    return $content;
}
?>
