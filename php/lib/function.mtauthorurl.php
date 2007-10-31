<?php
function smarty_function_mtauthorurl($args, &$ctx) {
    $author = $ctx->stash('author');
    if (!$author) {
        return $ctx->error("No author available");
    }
    return isset($author['author_url']) ? $author['author_url'] : '';
}
?>
