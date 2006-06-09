<?php
function smarty_function_MTStaticWebPath($args, &$ctx) {
    $path = $ctx->mt->config['StaticWebPath'];
    if (!$path) {
        require_once "function.MTCGIPath.php";
        $path = smarty_function_MTCGIPath($args, $ctx);
        $path .= 'mt-static/';
    } elseif (substr($path, 0, 1) == '/') {
        $blog = $ctx->stash('blog');
        $host = $blog['blog_site_url'];
        if (!preg_match('!/$!', $host))
            $host .= '/';
        if (preg_match('!^(https?://[^/:]+)(:\d+)?/!', $host, $matches)) {
            $path = $matches[1] . $path;
        }        
    }
    if (substr($path, strlen($path) - 1, 1) != '/')
        $path .= '/';
    return $path;
}
?>
