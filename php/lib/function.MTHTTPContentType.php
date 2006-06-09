<?php
function smarty_function_MTHTTPContentType($args, &$ctx) {
    $ctx->stash('content_type', $args['type']);
    return '';
}
?>
