<?php
function smarty_function_mthttperrorcode($args, &$ctx) {
    $err = $ctx->stash('http_error');
    return empty($err) ? '' : $err;
}
?>
