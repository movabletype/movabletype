<?php
function smarty_function_MTBlogDescription($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    return $blog['blog_description'];
}
?>
