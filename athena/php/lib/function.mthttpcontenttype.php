<?php
function smarty_function_mthttpcontenttype($args, &$ctx) {
    $ctx->stash('content_type', $args['type']);
    return '';
}
?>
