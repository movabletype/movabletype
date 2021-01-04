<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtadmincgipath($args, &$ctx) {
    // status: complete
    // parameters: none
    $path = $ctx->mt->config('AdminCGIPath');
    $path or $path = $ctx->mt->config('CGIPath');
    if (substr($path, 0, 1) == '/') {   # relative path
        $blog = $ctx->stash('blog');
        $host = $blog->site_url();
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
