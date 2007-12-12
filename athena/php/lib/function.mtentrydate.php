<?php
function smarty_function_mtentrydate($args, &$ctx) {
    $e = $ctx->stash('entry');
    $args['ts'] = $e['entry_authored_on'];
    return $ctx->_hdlr_date($args, $ctx);
}
?>
