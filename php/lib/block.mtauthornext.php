<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtauthornext($args, $content, &$ctx, &$repeat) {
    static $_next_cache = array();
    if (!isset($content)) {
        $next_author = null;
        $ctx->localize(array('author'));
        $author = $ctx->stash('author');
        if ($author) {
            $author_id = $author->author_id;
            if (isset($_next_cache[$author_id])) {
                $next_author = $_next_cache[$author_id];
            } else {
                $name = $author->author_name;
                $blog_id = $ctx->stash('blog_id');
                $args = array('sort_by' => 'author_name',
                              'sort_order' => 'ascend',
                              'start_string' => $name,
                              'lastn' => 1,
                              'blog_id' => $blog_id,
                              'need_entry' => 1);
                list($next_author) = $ctx->mt->db()->fetch_authors($args);
            }
            if ($next_author) {
              $_next_cache[$author_id] = $next_author;
              $ctx->stash('author', $next_author);
            } else
              $repeat = false;
        } else {
            $repeat = false;
        }
    } else {
        $ctx->restore(array('author'));
    }
    return $content;
}
?>
