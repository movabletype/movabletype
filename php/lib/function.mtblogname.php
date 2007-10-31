<?php
function smarty_function_mtblogname($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    return $blog['blog_name'];
}
?>
