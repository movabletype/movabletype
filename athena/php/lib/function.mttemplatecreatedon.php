<?php
function smarty_function_mttemplatecreatedon($args, &$ctx) {
    $args['ts'] = $ctx->stash('template_created_on');
    return $ctx->_hdlr_date($args, $ctx);
}
?>
