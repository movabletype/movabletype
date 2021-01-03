<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtassetblogid($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    return (isset($args['pad']) && $args['pad']) ? sprintf("%06d", $asset->asset_blog_id) : $asset->asset_blog_id;
}
?>
