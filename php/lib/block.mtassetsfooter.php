<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtassetsfooter.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtassetsfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $assets = $ctx->stash('_assets');
        $counter = $ctx->stash('_assets_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, count($assets) == $counter);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
