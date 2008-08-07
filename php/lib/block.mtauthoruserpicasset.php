<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtauthoruserpicasset($args, $content, &$ctx, &$repeat) {
    $author = $ctx->stash('author');
    if (empty($author)) {
        $entry = $ctx->stash('entry');
        if (!empty($entry)) {
            $author = $ctx->mt->db->fetch_author($entry['entry_author_id']);
        }
    }
    if (empty($author)) {
        return $ctx->error("No author available");
    }

    $asset_id = isset($author['author_userpic_asset_id']) ? $author['author_userpic_asset_id'] : 0;
    $asset = $ctx->mt->db->fetch_assets(array('id' => $asset_id));
    if (!$asset) return '';

    $ctx->stash('asset',  $asset[0]);

    return $content;
}
?>
