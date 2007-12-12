<?php
function smarty_function_mtentryauthorurl($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['author_url'];
}
?>
