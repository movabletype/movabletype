<?php
function smarty_function_mtauthorid($args, &$ctx) {
    $author = $ctx->stash('author');
    if (!$author) {
        return $ctx->error("No author available");
    }
    return $author['author_id'];
}
?>
