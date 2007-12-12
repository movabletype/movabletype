<?php
function smarty_function_mtsignonurl($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('SignOnURL');
}
?>
