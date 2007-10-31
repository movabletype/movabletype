<?php
function smarty_function_mtauthoremail($args, &$ctx) {
    $author = $ctx->stash('author');
    if (!$author) {
        return $ctx->error("No author available");
    }
     return isset($author['author_email']) ? $author['author_email'] : '';
}
?>
