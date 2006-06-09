<?php
function smarty_function_MTEntryKeywords($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['entry_keywords'];
}
?>
