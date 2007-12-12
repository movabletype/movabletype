<?php
function smarty_function_mtpingurl($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_source_url'];
}
?>
