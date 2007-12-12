<?php
function smarty_block_mtifauthor($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ok = $ctx->stash('author') ? 1 : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ok);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
