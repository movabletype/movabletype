<?php
function smarty_function_MTHTTPErrorCode($args, &$ctx) {
    $err = $ctx->stash('http_error');
    return empty($err) ? '' : $err;
}
?>
