<?php
function smarty_function_mtblogid($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->stash('blog_id');
}
?>
