<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("function.mtasseturl.php");
function smarty_function_mtassetlink($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    $target = "";
    $link = "";
    if (isset($args['new_window']))
        $target = " target=\"_blank\"";

    $url = smarty_function_mtasseturl($args, $_smarty_tpl);

    return sprintf("<a href=\"%s\"%s>%s</a>",
        $url,
        $target,
        $asset->asset_file_name);
}
?>
