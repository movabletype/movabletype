<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtblogsitepath($args, &$ctx) {
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

    $path = $blog->site_path();
    if (!preg_match('!/$!', $path))
        $path .= '/';
    return $path;
}
?>
