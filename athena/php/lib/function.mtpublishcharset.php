<?php
function smarty_function_mtpublishcharset($args, &$ctx) {
    // Status: complete
    // parameters: none
    $charset = $ctx->mt->config('PublishCharset');
    $charset or $charset = 'utf-8';
    return $charset;
}
?>
