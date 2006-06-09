<?php
function smarty_function_MTTypeKeyToken($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    return $blog['blog_remote_auth_token'];
}
?>
