<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

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

    $link =sprintf('<img src="%s?%d" %s alt="%s" />',
                   encode_html($userpic_url), $asset_id, $dimensions, encode_html($asset[0]->label));

    return $link;
}
?>
