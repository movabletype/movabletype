<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("function.mtasseturl.php");
function smarty_function_mtassetthumbnaillink($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';
    if ($asset->asset_class != 'image') return '';
    $blog = $ctx->stash('blog');
    if (!$blog) return '';

    if( !isset($args['force']) || !$args['force'] ){
        if ( isset($args['width']) && $args['width'] > $asset->asset_image_width )
            unset($args['width']);
        if ( isset($args['height']) && $args['height'] > $asset->asset_image_height )
            unset($args['height']);
    }

    require_once('MTUtil.php');

    $props = get_thumbnail_file($asset, $blog, $args);
    
    if (empty($props)) {
        return '';
    }

    list($thumb, $thumb_w, $thumb_h) = $props;

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
