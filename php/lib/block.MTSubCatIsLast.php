<?php
function smarty_block_MTSubCatIsLast($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'subCatIsLast');
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
