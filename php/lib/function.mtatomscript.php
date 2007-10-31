<?php
function smarty_function_mtatomscript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('AtomScript');
}
?>
