<?php
function smarty_function_mtassetlink($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    $target = "";
    $link = "";
    if (isset($args['new_window']))
        $target = " target=\"_blank\"";

    return sprintf("<a href=\"%s\"%s>%s</a>",
        $asset['asset_url'],
        $target,
        $asset['asset_file_name']);
}
?>

