<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mttoplevelcategories($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ctx->localize(array('category', 'archive_category'));
        $ctx->stash('category', null);
        $ctx->stash('archive_category', null);
        require_once("block.mtsubcategories.php");
        $args['top_level_categories'] = 1;
    }
    $result = smarty_block_mtsubcategories($args, $content, $ctx, $repeat);
    if (!$repeat) {
        $ctx->restore(array('category', 'archive_category'));
    }
    return $result;
}
?>
