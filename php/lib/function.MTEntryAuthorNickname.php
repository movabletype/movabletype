<?php
function smarty_function_MTEntryAuthorNickname($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    return $entry['author_nickname'];
}
?>
