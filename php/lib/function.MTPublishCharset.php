<?php
function smarty_function_MTPublishCharset($args, &$ctx) {
    // Status: complete
    // parameters: none
    if ($ctx->mt->config['PublishCharset']) {
        return $ctx->mt->config['PublishCharset'];
    } else {
        return 'iso-8859-1';
    }
}
?>
