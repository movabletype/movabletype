<?php
function smarty_function_mtauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $author = $ctx->stash('entry');
    $author = $author['author_ic'];
    return $author;
}
?>
