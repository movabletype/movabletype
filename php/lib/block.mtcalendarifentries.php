<?php
function smarty_block_mtcalendarifentries($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarIfEntries');
}
?>
