<?php
function smarty_block_mtcalendarifblank($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarIfBlank');
}
?>
