<?php
# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtblogurl($args, &$ctx) {
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

    $url = $blog->site_url();
    if (!preg_match('!/$!', $url))
        $url .= '/';
    return $url;
}
?>
