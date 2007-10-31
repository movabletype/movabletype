<?php
function smarty_function_mtcommenterauthtype($args, &$ctx) {
    $a =& $ctx->stash('commenter');
    return isset($a) ? $a['author_auth_type'] : '';
}
?>
