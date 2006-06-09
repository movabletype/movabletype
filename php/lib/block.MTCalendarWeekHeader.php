<?php
function smarty_block_MTCalendarWeekHeader($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarWeekHeader');
}
?>
