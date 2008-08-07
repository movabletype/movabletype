<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtasset($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $asset = $ctx->mt->db->fetch_assets($args);
    } else {
        $asset = array();
    }

    if (count($asset) == 1) {
        $ctx->stash('asset',  $asset[0]);
        $ctx->stash('_assets_counter', 1);
        $repeat = true;
    } else {
        $repeat = false;
    }

    return $content;
}
?>

