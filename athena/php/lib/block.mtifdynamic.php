<?php
function smarty_block_mtifdynamic($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 1);
}
?>
