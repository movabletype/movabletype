<?php
function smarty_function_MTEntryDate($args, &$ctx) {
    $e = $ctx->stash('entry');
    $args['ts'] = $e['entry_created_on'];
    return $ctx->_hdlr_date($args, $ctx);
}
?>
