<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifisancestor($args, $content, &$ctx, &$repeat) {
    $localvars = array('conditional', 'else_content');
    if (!isset($content)) {
       require_once("MTUtil.php");
       $cat = get_category_context($ctx);
       $ctx->localize($localvars);
       $children = $ctx->mt->db()->fetch_categories(array('label' => $args['child'], 'blog_id' => $ctx->stash('blog_id'), 'show_empty' => 1));
       $ret = false;
       if ($children) {
           foreach ($children as $child) {
               if (_is_ancestor($cat, $child, $ctx)) {
                   $ret = true;
                   break;
               }
           }
           unset($child);
       }
       $ctx->stash('else_content', null);
       $ctx->stash('conditional', $ret ? 1 : 0);
    } else {
       if (!$ctx->stash('conditional'))
           $content = $ctx->stash('else_content');
       $ctx->restore($localvars);
    }
    return $content;
}

function _is_ancestor($cat, $possible_child, $ctx) {
    # Catch the different blog edge case
    if ($cat->category_blog_id != $possible_child->category_blog_id) 
        return 0;

    if ($cat->category_id == $possible_child->category_id)
        return 1;

    # Keep having the child bump up one level in the hierarchy
    # to see if it ever reaches the current category
    # (more efficient than descending from the current category
    # as the children lists do not need to be calculated)
    while ($id = $possible_child->category_parent) {
        $possible_child = $ctx->mt->db()->fetch_category($id);
        if ($cat->category_id == $id)
            return 1;
    }

    # Looks like we didn't find it
    return 0;
}
?>
