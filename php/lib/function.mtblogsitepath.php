<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
