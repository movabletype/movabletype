<?php
function smarty_block_mtpingsfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $pings = $ctx->stash('_pings');
        $counter = $ctx->stash('_pings_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $counter == count($pings));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
