<?php
function smarty_function_mtentryauthorid($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    return $entry['entry_author_id'];
}
?>
