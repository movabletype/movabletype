<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtblogrelativeurl($args, &$ctx) {
    // status: complete
    // parameters: none
    if (isset($args['id']) && is_numeric($args['id'])) {
        require_once('class.mt_blog.php');
        $blog = new Blog();
        $ret = $blog->Load('blog_id = '.$args['id']);
        if (!$ret)
            $blog = null;
    }
    if (empty($blog)) {
        $blog = $ctx->stash('blog');
    }
    if (empty($blog))
        return '';

    $host = $blog->site_url();
    if (!preg_match('!/$!', $host))
        $host .= '/';

    if (preg_match('!^https?://[^/]+(/.*)$!', $host, $matches))
        return $matches[1];
    else
        return '';
}
?>
