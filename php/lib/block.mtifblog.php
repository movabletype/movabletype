<?php
function smarty_block_mtifblog($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ok = $ctx->stash('blog') ? 1 : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ok);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
