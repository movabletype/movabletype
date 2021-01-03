<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function get_parent_categories(&$cat, &$ctx, &$list, $class = 'category') {
    if ($cat->category_parent) {
        if ($class == 'folder')
            $parent = $ctx->mt->db()->fetch_folder($cat->category_parent);
        else
            $parent = $ctx->mt->db()->fetch_category($cat->category_parent);
        if ($parent) {
            $cat->parent_category = $parent;
            array_unshift($list, 0); $list[0] =& $parent;
            get_parent_categories($parent, $ctx, $list, $class);
        }
    }
}

function smarty_block_mtparentcategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('_categories', 'category', '_categories_counter','glue', '__out');
    if (!isset($content)) {
        $ctx->localize($localvars);
        require_once("MTUtil.php");
        $class = isset($args) && isset($args['class']) ? $args['class'] : 'category';
        $cat = get_category_context($ctx, $class);
        $parents = array();
        get_parent_categories($cat, $ctx, $parents, $class);
        if (!isset($args['exclude_current']) || ($args['exclude_current'] == 0)) {
            $parents[] = $cat;
        }
        if (isset($args['glue'])) {
            $glue = $args['glue'];
        } else {
            $glue = '';
        }
        $ctx->stash('_categories', $parents);
        $ctx->stash('glue', $glue);
        $ctx->stash('__out', false);
        $counter = 0;
    } else {
        $parents = $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
        $glue = $ctx->stash('glue');
        $out = $ctx->stash('__out');
    }

    if (is_array($parents) && $counter < count($parents)) {
        $ctx->stash('category', $parents[$counter]);
        $ctx->stash('_categories_counter', $counter + 1);
        $repeat = true;
        if (!empty($glue) && !empty($content)) {
            if ($out)
                $content = $glue . $content;
            else
                $ctx->stash('__out', true);
        }
    } else {
        if (!empty($glue) && $out && !empty($content))
            $content = $glue . $content;
        $repeat = false;
        $glue = '';
        $ctx->restore($localvars);
    }
    return $content;
}
?>