<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("function.mtasseturl.php");
function smarty_function_mtassetlink($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    $target = "";
    $link = "";
    if (isset($args['new_window']))
        $target = " target=\"_blank\"";

    $url = smarty_function_mtasseturl($args, $ctx);

    return sprintf("<a href=\"%s\"%s>%s</a>",
        $url,
        $target,
        $asset->asset_file_name);
}
?>
