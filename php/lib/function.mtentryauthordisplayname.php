<?php
function smarty_function_mtentryauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    $author = $entry['author_nickname'];
    return $author;
}
?>
