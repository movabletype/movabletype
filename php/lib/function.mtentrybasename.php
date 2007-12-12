<?php
function smarty_function_mtentrybasename($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    return $entry['entry_basename'];
}
?>
