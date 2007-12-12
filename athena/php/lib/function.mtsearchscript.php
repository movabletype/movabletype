<?php
function smarty_function_mtsearchscript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('SearchScript');
}
?>
