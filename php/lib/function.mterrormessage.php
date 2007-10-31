<?php
function smarty_function_mterrormessage($args, &$ctx) {
    // status: complete
    // parameters: none
    $err = $ctx->stash('error_message');
    return empty($err) ? '' : $err;
}
?>
