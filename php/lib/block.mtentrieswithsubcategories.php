<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtentrieswithsubcategories.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtentrieswithsubcategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('entries', 'inside_with_subcategories');
    if (!isset($content)) {
        $cat = $args['category'];
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