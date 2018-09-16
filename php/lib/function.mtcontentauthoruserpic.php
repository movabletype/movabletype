<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentauthoruserpic($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content)) return '';

    $author = $content->author();
    if (!$author) return '';

    $asset_id = isset($author->author_userpic_asset_id) ? $author->author_userpic_asset_id : 0;
    $asset = $ctx->mt->db()->fetch_assets(array('id' => $asset_id));
    if (!$asset) return '';

    $blog =& $ctx->stash('blog');

    require_once("MTUtil.php");
    $userpic_url = userpic_url($asset[0], $blog, $author);
    if (empty($userpic_url))
        return '';

    $size   = 0;
    $width  = $asset[0]->asset_image_width;
    $height = $asset[0]->asset_image_height;
    if ($width > $height) {
        $size = $height;
    } else {
        $size = $width;
    }

    $mt = MT::get_instance();
    if (!$size || $size > $mt->config('UserpicThumbnailSize')) {
        $size = $mt->config('UserpicThumbnailSize');
    }

    $dimensions = sprintf('width="%s" height="%s"', $size, $size);

    $link =sprintf('<img src="%s?%d" %s alt="%s" />',
                   encode_html($userpic_url), $asset_id, $dimensions, encode_html($asset[0]->label));

    return $link;
}
?>
