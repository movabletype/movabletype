<?php
function smarty_function_mtassettype($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    global $mt;
    return $mt->translate($asset['asset_class']);
}
?>
