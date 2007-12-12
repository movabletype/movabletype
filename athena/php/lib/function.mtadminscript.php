<?php
function smarty_function_mtadminscript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('AdminScript');
}
?>
