<?php
function smarty_block_MTEntriesFooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entries =& $ctx->stash('entries');
        $counter = $ctx->stash('_entries_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $counter == count($entries));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
