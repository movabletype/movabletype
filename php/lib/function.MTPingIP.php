<?php
function smarty_function_MTPingIP($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_ip'];
}
?>
