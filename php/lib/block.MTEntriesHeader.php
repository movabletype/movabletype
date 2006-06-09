<?php
function smarty_block_MTEntriesHeader($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ctx->stash('_entries_counter') == 1);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
