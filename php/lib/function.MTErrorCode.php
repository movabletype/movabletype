<?php
function smarty_function_MTErrorCode($args, &$ctx) {
    $err = $ctx->stash('error_code');
    return empty($err) ? '' : $err;
}
?>
