<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcommenteruserpicasset($args, $content, &$ctx, &$repeat) {
    $comment = $ctx->stash('comment');
    if (!$comment) {
        return $ctx->error("No comments available");
    }
    $cmntr = $ctx->stash('commenter');
    if (!$cmntr) return '';

    $asset = $cmntr->userpic();
    if (!$asset) return '';

    $ctx->stash('asset',  $asset);

    return $content;
}
?>
