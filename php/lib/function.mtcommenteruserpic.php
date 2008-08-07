<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommenteruserpic($args, &$ctx) {
    $comment = $ctx->stash('comment');
    if (!$comment) {
        return $ctx->error("No comment available");
    }
    $cmntr = $ctx->stash('commenter');
    if (!$cmntr) return '';

    $asset_id = isset($cmntr['author_userpic_asset_id']) ? $cmntr['author_userpic_asset_id'] : 0;
    $asset = $ctx->mt->db->fetch_assets(array('id' => $asset_id));
    if (!$asset) return '';

    $blog =& $ctx->stash('blog');

    require_once("MTUtil.php");
    $userpic_url = userpic_url($asset[0], $blog, $cmntr);
    if (empty($userpic_url))
        return '';

    $asset_path = asset_path($asset[0]['asset_file_path'], $blog);
    list($src_w, $src_h, $src_type, $src_attr) = getimagesize($asset_path);
    $dimensions = sprintf('width="%s" height="%s"', $src_w, $src_h);

    $link =sprintf('<img src="%s" %s alt="%s" />',
                   encode_html($userpic_url), $dimensions, encode_html($asset['label']));

    return $link;
}
?>
