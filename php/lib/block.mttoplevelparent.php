<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mttoplevelparent($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ctx->localize(array('category','conditional','else_content'));
        require_once("MTUtil.php");
        $cat = get_category_context($ctx);
        require_once("block.mtparentcategories.php");
        $list = array();
        get_parent_categories($cat, $ctx, $list);
        $ctx->stash('else_content', null);
        if (count($list) > 0) {
            $cat = array_pop($list);
            $ctx->stash('category', $cat);
        }
        $ctx->stash('conditional', $cat ? 1 : 0);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('category','conditional','else_content'));
    }
    return $content;
}
?>
