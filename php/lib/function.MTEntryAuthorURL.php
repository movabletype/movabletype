<?php
function smarty_function_MTEntryAuthorURL($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['author_url'];
}
?>
