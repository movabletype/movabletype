<?php
function smarty_function_MTPingID($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_id'];
}
?>
