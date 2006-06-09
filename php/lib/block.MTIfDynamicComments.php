<?php
function smarty_block_MTIfDynamicComments($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
}
?>
