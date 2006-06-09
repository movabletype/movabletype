<?php
function smarty_function_MTBlogHost($args, &$ctx) {
    // status: complete
    // parameters: exclude_port
    $blog = $ctx->stash('blog');
    $host = $blog['blog_site_url'];
    if (!preg_match('!/$!', $host))
        $host .= '/';

    if (preg_match('!^https?://([^/:]+)(:\d+)?/!', $host, $matches)) {
        return (isset($args['exclude_port']) && ($args['exclude_port'])) ? $matches[1] : $matches[1] . (isset($matches[2]) ? $matches[2] : '');
    } else {
        return '';
    }
}
?>
