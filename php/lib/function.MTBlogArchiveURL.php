<?php
function smarty_function_MTBlogArchiveURL($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    return $blog['blog_archive_url'];
}
?>
