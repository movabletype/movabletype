<?php
function smarty_function_mtauthorauthtype($args, &$ctx) {
    $author = $ctx->stash('author');
    if (!$author) {
        return $ctx->error("No author available");
    }
    return isset($author['author_auth_type']) ? $author['author_auth_type'] : '';
}
?>
