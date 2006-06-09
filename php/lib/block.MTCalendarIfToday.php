<?php
function smarty_block_MTCalendarIfToday($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarIfToday');
}
?>
