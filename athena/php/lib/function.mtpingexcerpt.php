<?php
function smarty_function_mtpingexcerpt($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_excerpt'];
}
?>
