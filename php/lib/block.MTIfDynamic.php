<?php
function smarty_block_MTIfDynamic($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 1);
}
?>
