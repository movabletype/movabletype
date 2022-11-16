<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtassetthumbnailurl($args, &$ctx) {
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

    return (isset($props[0]) && is_array($props) ? $props[0] : null);
}
?>
