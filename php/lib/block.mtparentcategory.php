<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtparentcategory($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ctx->localize(array('category', 'conditional', 'else_content'));
        require_once("MTUtil.php");
        $cat = get_category_context($ctx);
        if (($cat) && ($cat['category_parent'])) {
            $parent_cat = $ctx->mt->db->fetch_category($cat['category_parent']);
            $ctx->stash('category', $parent_cat);
        }
        $ctx->stash('conditional', isset($parent_cat));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('category', 'conditional', 'else_content'));
    }
    return $content;
}
?>
