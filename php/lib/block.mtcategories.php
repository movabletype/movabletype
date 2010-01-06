<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcategories($args, $content, &$ctx, &$repeat) {
    // status: incomplete
    // parameters: show_empty
    $localvars = array('_categories', '_categories_counter', 'category', 'inside_mt_categories', 'entries', '_categories_glue', 'blog_id', 'blog', '__out');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $args['blog_id'] = $ctx->stash('blog_id');
        $categories = $ctx->mt->db()->fetch_categories($args);
        $glue = $args['glue'];
        $ctx->stash('_categories_glue', $glue);
        $ctx->stash('_categories', $categories);
        $ctx->stash('inside_mt_categories', 1);
        $ctx->stash('show_empty', isset($args['show_empty']) ? $args['show_empty'] : '0');
        $ctx->stash('__out', false);
        $counter = 0;
    } else {
        $categories = $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
        $glue = $ctx->stash('_categories_glue');
        $out =$ctx->stash('__out');
    }
    if ($counter < count($categories)) {
        $category = $categories[$counter];
        $ctx->stash('category', $category);
        $ctx->stash('entries', null);
        $ctx->stash('_categories_counter', $counter + 1);
        $ctx->stash('blog_id', $category->category_blog_id);
        $ctx->stash('ArchiveListHeader', $counter == 0);
        $ctx->stash('ArchiveListFooter', $counter+1 == count($categories));
        $ctx->stash('blog',
                    $category->blog());
        if (!empty($glue) && !empty($content)) {
            if ($out)
                $content = $glue . $content;
            else
                $ctx->stash('__out', true);
        }
        $count = $counter + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($categories));
        $repeat = true;
    } else {
        if (!empty($glue) && $out && !empty($content))
            $content = $glue . $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
