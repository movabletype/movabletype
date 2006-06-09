<?php
function smarty_block_MTCalendarIfEntries($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarIfEntries');
}
?>
