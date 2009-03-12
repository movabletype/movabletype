<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("function.mtasseturl.php");
function smarty_function_mtassetthumbnaillink($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';
    if ($asset['asset_class'] != 'image') return '';
    $blog = $ctx->stash('blog');
    if (!$blog) return '';

    require_once('MTUtil.php');

    list($thumb, $thumb_w, $thumb_h) = get_thumbnail_file($asset, $blog, $args);
    if (empty($thumb)) {
        return '';
    }

    $target = "";
    if (isset($args['new_window']))
        $target = " target=\"_blank\"";

    $asset_url = smarty_function_mtasseturl($args, $ctx);

    return sprintf("<a href=\"%s\"%s><img src=\"%s\" width=\"%d\" height=\"%d\" alt=\"\" /></a>",
        $asset_url,
        $target,
        $thumb,
        $thumb_w,
        $thumb_h);
}
?>

