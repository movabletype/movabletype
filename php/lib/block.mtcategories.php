<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcategories($args, $content, &$ctx, &$repeat) {
    // status: incomplete
    // parameters: show_empty
    $localvars = array('_categories', '_categories_counter', 'category', 'inside_mt_categories', 'entries', '_categories_glue', 'blog_id', 'blog');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $args['blog_id'] = $ctx->stash('blog_id');
        $categories = $ctx->mt->db->fetch_categories($args);
        $glue = $args['glue'];
        $ctx->stash('_categories_glue', $glue);
        $ctx->stash('_categories', $categories);
        $ctx->stash('inside_mt_categories', 1);
        $ctx->stash('show_empty', isset($args['show_empty']) ? $args['show_empty'] : '0');
        $counter = 0;
    } else {
        $categories = $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
        $glue = $ctx->stash('_categories_glue');
    }
    if ($counter < count($categories)) {
        $category = $categories[$counter];
        $ctx->stash('category', $category);
        $ctx->stash('entries', null);
        $ctx->stash('_categories_counter', $counter + 1);
        $ctx->stash('blog_id', $category['category_blog_id']);
        $ctx->stash('ArchiveListHeader', $counter == 0);
        $ctx->stash('ArchiveListFooter', $counter+1 == count($categories));
        $ctx->stash('blog',
            $ctx->mt->db->fetch_blog($category['category_blog_id']));
        if ($counter > 0) $content = $content . $glue;
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
