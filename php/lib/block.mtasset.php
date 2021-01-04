<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtasset($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $asset = $ctx->mt->db()->fetch_assets($args);
    } else {
        $asset = array();
    }

    if (is_array($asset) && count($asset) == 1) {
        $ctx->stash('asset',  $asset[0]);
        $ctx->stash('_assets_counter', 1);
        $repeat = true;
    } else {
        $repeat = false;
    }

    return $content;
}
?>
