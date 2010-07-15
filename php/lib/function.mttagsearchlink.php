<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mttagsearchlink($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_object($tag)) {
        $name = $tag->tag_name;
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
        $param = 'IncludeBlogs=' . $blog_id;
    }

    $tmpl_blog_id = null;
    if ( isset( $args['tmpl_blog_id'] ) ) {
        $tmpl_blog_id = $args['tmpl_blog_id'];
        if ( !preg_match( '/^\d+$/', $tmpl_blog_id ) || $tmpl_blog_id < 1 ) {
            $mt = MT::get_instance();
            $ctx->error( $mt->translate( 'Invalid [_1] parameter.', 'tmpl_blog_id' ) );
        }

        if ( 'parent' == strtolower( $tmpl_blog_id ) ) {
            $blog = $ctx->stash('blog');
            if ( $blog->is_blog ) {
                $blog = $blog->website();
            }
            $tmpl_blog_id = $blog->id;
        }
    }

    require_once "function.mtcgipath.php";
    $search = smarty_function_mtcgipath($args, $ctx);
    $search .= $ctx->mt->config('SearchScript');
    $link = $search . '?' . $param . ($param ? '&amp;' : '')
        . 'tag=' . urlencode($name);
    $link .= '&amp;limit=' . $ctx->mt->config('MaxResults');
    if ( $tmpl_blog_id )
        $link .= '&amp;blog_id=' . $tmpl_blog_id;
    return $link;
}
?>
