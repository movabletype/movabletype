<?php
function smarty_function_mtassetfilename($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    return $asset['asset_file_name'];
}
?>

