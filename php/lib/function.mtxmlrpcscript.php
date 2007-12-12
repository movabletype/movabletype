<?php
function smarty_function_mtxmlrpcscript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('XMLRPCScript');
}
?>
