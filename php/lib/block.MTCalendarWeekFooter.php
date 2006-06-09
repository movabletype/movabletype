<?php
function smarty_block_MTCalendarWeekFooter($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarWeekFooter');
}
?>
