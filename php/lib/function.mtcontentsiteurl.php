<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentsiteurl($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content)) return '';

    $blog = $ctx->stash('blog');
    if ($blog) {
        $url = $blog->site_url();
        if (!preg_match('!/$!', $url))
            $url .= '/';
        return $url;
    }
    return '';
}
?>
