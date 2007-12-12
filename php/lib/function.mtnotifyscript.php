<?php
function smarty_function_mtnotifyscript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('NotifyScript');
}
?>
