<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtparentcategory($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ctx->localize(array('category', 'conditional', 'else_content'));
        $class = isset($args) && isset($args['class']) ? $args['class'] : 'category';
        require_once("MTUtil.php");
        $cat = get_category_context($ctx, $class);
        if (($cat) && ($cat->category_parent)) {
            if ($class == 'folder')
                $parent_cat = $ctx->mt->db()->fetch_folder($cat->category_parent);
            else
                $parent_cat = $ctx->mt->db()->fetch_category($cat->category_parent);
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
