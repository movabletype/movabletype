<?php
function smarty_function_mtauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $author = $ctx->stash('author');
    $author_name = $author['author_nickname'];
    $author_name or $author_name =
        $ctx->mt->translate('(Display Name not set)');
    return $author_name;
}
?>
