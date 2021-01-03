<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsiteurl($args, &$ctx) {
    // status: complete
    // parameters: none
    if (isset($args['id']) && is_numeric($args['id'])) {
        require_once('class.mt_website.php');
        $blog = new Blog();
        $ret = $blog->Load('blog_id = '.$args['id']);
        if (!$ret)
            $blog = null;
    }
    if (empty($blog)) {
        $blog = $ctx->stash('blog');
    }
    if (empty($blog)) return '';
    $website = $blog->is_blog() ? $blog->website() : $blog;
    if (empty($website)) return '';

    $url = $website->site_url();
    if (!preg_match('!/$!', $url))
        $url .= '/';
    return $url;
}
?>
