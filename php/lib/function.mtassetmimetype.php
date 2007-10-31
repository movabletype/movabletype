<?php
function smarty_function_mtassetmimetype($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    return $asset['asset_mime_type'];
}
?>

