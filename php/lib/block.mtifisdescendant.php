<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifisdescendant($args, $content, &$ctx, &$repeat) {
    $localvars = array('conditional', 'else_content');
    if (!isset($content)) {
       require_once("MTUtil.php");
       $cat = get_category_context($ctx);
       $ctx->localize($localvars);
       $parents = $ctx->mt->db()->fetch_categories(array('label' => $args['parent'], 'blog_id' => $ctx->stash('blog_id'), 'show_empty' => 1));
       $ret = false;
       if ($parents) {
           require_once("block.mtifisancestor.php");
           foreach ($parents as $parent) {
               if (_is_ancestor($parent, $cat, $ctx)) {
                   $ret = true;
                   break;
               }
           }
           unset($parent);
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
?>
