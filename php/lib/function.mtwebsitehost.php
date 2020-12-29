<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitehost($args, &$ctx) {
    // status: complete
    // parameters: exclude_port, signature
    $blog = $ctx->stash('blog');
    if (empty($blog)) return '';
    $website = $blog->is_blog() ? $blog->website() : $blog;
    if (empty($website)) return '';
    $host = $website->site_url();
    if (!preg_match('!/$!', $host))
        $host .= '/';

    if (preg_match('!^https?://([^/:]+)(:\d+)?/?!', $host, $matches)) {
        if ($args['signature']) {
            $sig = $matches[1];
            $sig = preg_replace('/\./', '_', $sig);
            return $sig;
        }
        return (isset($args['exclude_port']) && ($args['exclude_port'])) ? $matches[1] : $matches[1] . (isset($matches[2]) ? $matches[2] : '');
    } else {
        return '';
    }
}
?>
