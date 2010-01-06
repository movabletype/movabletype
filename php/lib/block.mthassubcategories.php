<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mthassubcategories($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $class = 'category';
        if (isset($args['class'])){
            $class = $args['class'];
        }
        $has_sub_cats = _has_sub_categories($ctx, $class);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_sub_cats);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}

function _has_sub_categories(&$ctx, $class = 'category') {
    $class = isset($args) && isset($args['class']) ? $args['class'] : 'category';
    require_once("MTUtil.php");
    $cat = get_category_context($ctx, $class);
    $has_sub_cats = 0;
    if (isset($cat['_children'])) {
        $has_sub_cats = count($cat['_children']) > 0;
    } else {
        $cats =& $ctx->mt->db->fetch_categories(array('blog_id' => $ctx->stash('blog_id'), 'category_id' => $cat['category_id'], 'children' => 1, 'show_empty' => 1, 'class' => $class));
        if (isset($cats)) {
            $cat['_children'] = $cats;
            $has_sub_cats = count($cats) > 0;
        }
    }
    return $has_sub_cats;
}
?>
