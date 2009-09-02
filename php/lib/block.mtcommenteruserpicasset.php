<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtcommenteruserpicasset.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtcommenteruserpicasset($args, $content, &$ctx, &$repeat) {
    $comment = $ctx->stash('comment');
    if (!$comment) {
        return $ctx->error("No comment available");
    }
    $cmntr = $ctx->stash('commenter');
    if (!$cmntr) return '';

    $asset = $cmntr->userpic();
    if (!$asset) return '';

    $ctx->stash('asset',  $asset);

    return $content;
}
?>
