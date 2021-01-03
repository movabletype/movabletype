<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mtcategories.php');
function smarty_block_mtfolders($args, $content, &$ctx, &$repeat) {
    // status: incomplete
    // parameters: show_empty

    $localvars = array('category_set');

    if (!isset($content)) {
        $args['class'] = 'folder';
        unset($args['category_set_id']);

        $ctx->localize($localvars);
        $ctx->stash('category_set', null);
    }

    $ret = smarty_block_mtcategories($args, $content, $ctx, $repeat);

    if (!$repeat) {
        $ctx->restore($localvars);
    }

    return $ret;
}
?>
