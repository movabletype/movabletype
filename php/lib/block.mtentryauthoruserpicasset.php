<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtentryauthoruserpicasset.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtentryauthoruserpicasset($args, $content, &$ctx, &$repeat) {
    $entry = $ctx->stash('entry');
    if (!$entry) {
        return $ctx->error("No entry available");
    }

    $author = $entry->author();
    if (!$author) return '';

    $asset = $author->userpic();
    if (!$asset) return '';

    $ctx->stash('asset',  $asset);

    return $content;
}
?>
