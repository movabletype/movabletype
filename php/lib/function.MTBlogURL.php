<?php
function smarty_function_MTBlogURL($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    $url = $blog['blog_site_url'];
    if (!preg_match('!/$!', $url))
        $url .= '/';
    return $url;
}
?>
