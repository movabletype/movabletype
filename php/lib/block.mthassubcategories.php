<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mthassubcategories.php 106007 2009-07-01 11:33:43Z ytakayama $

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
    require_once("MTUtil.php");
    $cat = get_category_context($ctx, $class);
    $has_sub_cats = 0;
    $children = $cat->children();
    if (isset($children)) {
        $has_sub_cats = count($cat->children()) > 0;
    } else {
        $cats =& $ctx->mt->db()->fetch_categories(array('blog_id' => $ctx->stash('blog_id'), 'category_id' => $cat->category_id, 'children' => 1, 'show_empty' => 1, 'class' => $class));
        if (isset($cats)) {
            $cat->children($cats);
            $has_sub_cats = count($cats) > 0;
        }
    }
    return $has_sub_cats;
}
?>
