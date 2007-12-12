<?php
function smarty_block_mtcalendarweekfooter($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarWeekFooter');
}
?>
