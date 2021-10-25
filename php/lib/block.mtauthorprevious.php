<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtauthorprevious($args, $content, &$ctx, &$repeat) {
    static $_prev_cache = array();
    if (!isset($content)) {
        $prev_author = null;
        $ctx->localize(array('author'));
        $author = $ctx->stash('author');
        if ($author) {
            $author_id = $author->author_id;
            if (isset($_prev_cache[$author_id])) {
                $prev_author = $_prev_cache[$author_id];
            } else {
                $name = $author->author_name;
                $blog_id = $ctx->stash('blog_id');
                $args = array('sort_by' => 'author_name',
                              'sort_order' => 'descend',
                              'start_string' => $name,
                              'lastn' => 1,
                              'blog_id' => $blog_id,
                              'need_content' => 1);
                $authors = $ctx->mt->db()->fetch_authors($args);
                $prev_author = isset($authors[0]) ? $authors[0] : null;
            }
            if ($prev_author) {
              $_prev_cache[$author_id] = $prev_author;
              $ctx->stash('author', $prev_author);
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
