<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsiterelativeurl($args, &$ctx) {
    // status: complete
    // parameters: none
    if (isset($args['id']) && is_numeric($args['id'])) {
        require_once('class.mt_website.php');
        $website = new Blog();
        $ret = $website->Load('blog_id = '.$args['id']);
        if (!$ret)
            $website = null;
    } else {
        $blog = $ctx->stash('blog');
        if (empty($blog)) return '';
        $website = $blog->is_blog() ? $blog->website() : $blog;
    }
    if (empty($website)) return '';

    $host = $website->site_url();
    if (!preg_match('!/$!', $host))
        $host .= '/';

    if (preg_match('!^https?://[^/]+(/.*)$!', $host, $matches))
        return $matches[1];
    else
        return '';
}
?>
