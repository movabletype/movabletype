<?php
function smarty_block_MTDateHeader($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'DateHeader');
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
