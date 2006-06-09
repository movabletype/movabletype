<?php
function smarty_function_MTEntryAuthorDisplayName($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    $author = $entry['author_nickname'];
    return $author;
}
?>
