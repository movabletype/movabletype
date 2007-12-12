<?php
function smarty_function_mtpingip($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_ip'];
}
?>
