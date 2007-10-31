<?php
function smarty_function_mtauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $author = $ctx->stash('author');
    $author_name = $author['author_nickname'];
    $author_name or $author_name =
        'Author (#'.$author['author_id'].')';
    return $author_name;
}
?>
