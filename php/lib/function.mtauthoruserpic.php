<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtauthoruserpic.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtauthoruserpic($args, &$ctx) {
    $author = $ctx->stash('author');
    if (empty($author)) {
        $entry = $ctx->stash('entry');
        if (!empty($entry)) {
            $author = $entry->author();
        }
    }
    if (empty($author)) {
        return $ctx->error("No author available");
    }

    $asset_id = isset($author->author_userpic_asset_id) ? $author->author_userpic_asset_id : 0;
    $asset = $ctx->mt->db()->fetch_assets(array('id' => $asset_id));
    if (empty($asset)) return '';

    $blog =& $ctx->stash('blog');

    require_once("MTUtil.php");
    $userpic_url = userpic_url($asset[0], $blog, $author);
    if (empty($userpic_url))
        return '';

    $mt = MT::get_instance();
    $dimensions = sprintf('width="%s" height="%s"', $mt->config('UserpicThumbnailSize'), $mt->config('UserpicThumbnailSize'));

    $link =sprintf('<img src="%s" %s alt="%s" />',
                   encode_html($userpic_url), $dimensions, encode_html($asset['label']));

    return $link;
}
?>
