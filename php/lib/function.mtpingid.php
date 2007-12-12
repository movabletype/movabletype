<?php
function smarty_function_mtpingid($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_id'];
}
?>
