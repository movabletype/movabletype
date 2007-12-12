<?php
function smarty_function_mterrorcode($args, &$ctx) {
    $err = $ctx->stash('error_code');
    return empty($err) ? '' : $err;
}
?>
