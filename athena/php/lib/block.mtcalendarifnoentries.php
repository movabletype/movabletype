<?php
function smarty_block_mtcalendarifnoentries($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarIfNoEntries');
}
?>
