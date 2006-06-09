<?php
function smarty_function_MTPingExcerpt($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_excerpt'];
}
?>
