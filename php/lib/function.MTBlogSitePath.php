<?php
function smarty_function_MTBlogSitePath($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $path = $blog['blog_site_path'];
    if (!preg_match('!/$!', $path))
        $path .= '/';
    return $path;
}
?>
