<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mttagsearchlink($args, &$ctx) {
    require_once('multiblog.php');
    multiblog_function_wrapper('mttagsearchlink', $args, $ctx);

    $mt  = MT::get_instance();
    $blog = $ctx->stash('blog');

    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_object($tag)) {
        $name = $tag->tag_name;
    } else {
        $name = $tag;
    }

    $param = '';
    $include_blogs = !empty($args['include_blogs']) ? $args['include_blogs'] : $ctx->stash('include_blogs');
    $include_blogs or $include_blogs = !empty($args['blog_ids']) ? $args['blog_ids'] : $ctx->stash('blog_ids');
    if ( $include_blogs ) {
        if ($include_blogs != 'all') {
            $incl = $mt->db()->parse_blog_ids( $include_blogs, $include_with_website );
            if ( !$blog->is_blog )
                array_unshift( $incl, $blog->id );
            $param = 'IncludeBlogs=' . implode(',', $incl);
        }
    }  else {
        $blog_id = $ctx->stash('blog_id');
        $param = 'IncludeBlogs=' . $blog_id;
    }
    if ($exclude_blogs = !empty($args['exclude_blogs']) ? $args['exclude_blogs'] : $ctx->stash('exclude_blogs')) {
        $excl = $mt->db()->parse_blog_ids( $exclude_blogs );
        $param = 'ExcludeBlogs=' . implode(',', $excl);
    }
    $tmpl_blog_id = null;
    if ( isset( $args['tmpl_blog_id'] ) ) {
        $tmpl_blog_id = $args['tmpl_blog_id'];
        if ( 'parent' == strtolower( $tmpl_blog_id ) ) {
            if ( $blog->is_blog ) {
                $blog = $blog->website();
            }
            $tmpl_blog_id = $blog->id;
        }
        else {
            if ( !preg_match( '/^\d+$/', $tmpl_blog_id ) || $tmpl_blog_id < 1 ) {
                $mt = MT::get_instance();
                $ctx->error( $mt->translate( 'Invalid [_1] parameter.', 'tmpl_blog_id' ) );
            }
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
