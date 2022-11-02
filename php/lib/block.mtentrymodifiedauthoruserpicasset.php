<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentrymodifiedauthoruserpicasset($args, $content, &$ctx, &$repeat) {
    $entry = $ctx->stash('entry');
    if (!$entry) {
        return $ctx->error("No entry available");
    }

    $author = $entry->modified_author();
    if (!$author) return '';

    $asset = $author->userpic();
    if (!$asset) return '';

    $ctx->stash('asset',  $asset);

    return $content;
}
?>
