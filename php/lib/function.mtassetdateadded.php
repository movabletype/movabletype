<?php
function smarty_function_mtassetdateadded($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';
    
    $args['ts'] = $asset['asset_created_on'];
    return $ctx->_hdlr_date($args, $ctx);
}
?>

