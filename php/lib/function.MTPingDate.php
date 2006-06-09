<?php
function smarty_function_MTPingDate($args, &$ctx) {
    $p = $ctx->stash('ping');
    $args['ts'] = $p['tbping_created_on'];
    return $ctx->_hdlr_date($args, $ctx);
}
?>
