<?php
function smarty_block_MTArchiveListHeader($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'ArchiveListHeader');
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
