<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentrieswithsubcategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('entries', 'inside_with_subcategories');
    if (!isset($content)) {
        $cat = isset($args['category']) ? $args['category'] : null;
        if (!$cat) {
            $cat = $ctx->stash('category');
            if (isset($cat))
                $args['category'] = $cat->category_label;
        }
        $args['include_subcategories'] = 1;
        $ctx->localize($localvars);
        $ctx->stash('entries', null);
        $ctx->stash('inside_with_subcategories', 1);
        require_once("block.mtentries.php");
    }
    $output = smarty_block_mtentries($args, $content, $ctx, $repeat);
    if (!$repeat)
        $ctx->restore($localvars);
    return $output;
}
?>
