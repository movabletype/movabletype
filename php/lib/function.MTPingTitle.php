<?php
function smarty_function_MTPingTitle($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_title'];
}
?>
