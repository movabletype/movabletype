<?php
function smarty_function_mtassetlabel($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    return $asset['asset_label'];
}
?>

