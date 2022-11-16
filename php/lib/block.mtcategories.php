<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcategories($args, $content, &$ctx, &$repeat) {
    // status: incomplete
    // parameters: show_empty
    $localvars = array(array('_categories', '_categories_counter', 'category', 'inside_mt_categories', 'entries', 'contents', '_categories_glue', 'blog_id', 'blog', '__out'), common_loop_vars());

    if (!isset($content)) {
        $ctx->localize($localvars);

        require_once('multiblog.php');
        multiblog_block_wrapper($args, $content, $ctx, $repeat);

        if (!(isset($args['category_set_id']) && $args['category_set_id'])) {
            if ($ctx->stash('category_set')) {
                $args['category_set_id'] = $ctx->stash('category_set')->id;
            } else {
                $args['category_set_id'] = 0;
            }
        }
        $args['sort_by'] = 'label';
        !empty($args['sort_order']) or $args['sort_order'] = 'ascend';
        $categories = $ctx->mt->db()->fetch_categories($args);
        $glue = isset($args['glue']) ? $args['glue'] : '';
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
    if (is_array($categories) && $counter < count($categories)) {
        $category = $categories[$counter];
        $ctx->stash('category', $category);
        $ctx->stash('entries', null);
        $ctx->stash('contents', null);
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
