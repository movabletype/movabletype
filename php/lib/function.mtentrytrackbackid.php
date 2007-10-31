<?php
function smarty_function_mtentrytrackbackid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['trackback_id'];
}
?>
