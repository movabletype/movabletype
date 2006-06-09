<?php
function smarty_block_MTCalendarIfBlank($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarIfBlank');
}
?>
