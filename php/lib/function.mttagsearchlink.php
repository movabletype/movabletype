<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mttagsearchlink($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_array($tag)) {
        $name = $tag['tag_name'];
    } else {
        $name = $tag;
    }

    $param = '';
    if ($include_blogs = $args['include_blogs'] ? $args['include_blogs'] : $ctx->stash('include_blogs')) {
        if ($args['include_blogs'] != 'all') {
            $param = 'IncludeBlogs=' . $include_blogs;
        }
    } elseif ($exclude_blogs = $args['exclude_blogs'] ? $args['exclude_blogs'] : $ctx->stash('exclude_blogs')) {
        $param = 'ExcludeBlogs=' . $exclude_blogs;
    } elseif ($blog_ids = $args['blog_ids'] ? $args['blog_ids'] : $ctx->stash('blog_ids')) {
        $param = 'IncludeBlogs=' . $blog_ids;
    } else {
        $blog_id = $ctx->stash('blog_id');
        $param = 'blog_id=' . $blog_id;
    }

    require_once "function.mtcgipath.php";
    $search = smarty_function_mtcgipath($args, $ctx);
    $search .= $ctx->mt->config('SearchScript');
    $link = $search . '?' . $param . ($param ? '&amp;' : '')
        . 'tag=' . urlencode($name);
    $link .= '&amp;limit=' . $ctx->mt->config('MaxResults');
    return $link;
}
