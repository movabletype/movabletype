<?php
function smarty_block_mtassetsfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $assets = $ctx->stash('_assets');
        $counter = $ctx->stash('_assets_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, count($assets) == $counter);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
