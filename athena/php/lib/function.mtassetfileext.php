<?php
function smarty_function_mtassetfileext($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    return $asset['asset_file_ext'];
}
?>

