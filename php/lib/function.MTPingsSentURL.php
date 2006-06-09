<?php
function smarty_function_MTPingsSentURL($args, &$ctx) {
    $url = $ctx->stash('ping_sent_url');
    return $url;
}
?>
