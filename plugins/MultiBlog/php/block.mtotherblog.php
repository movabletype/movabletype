<?php
# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

if (MULTIBLOG_ENABLED) {
function smarty_block_mtotherblog($args, $content, &$ctx, &$repeat) {
    $localvars = array('local_blog_id', 'blog_id', 'blog');
    if (!isset($content)) {
        $blog_id = $args['blog_id'];
        if (!$blog_id) {
            $repeat = false;
            return '';
        }

        $ctx->localize($localvars);

        // do permission checking...
        if ($blog_id) {
            list($attr, $blogs) = multiblog_filter_blogs($ctx, 'include_blogs', array($args['blog_id']));
            if (($attr != 'include_blogs') || !count($blogs) || ($blogs[0] != $blog_id)) {
                $repeat = false;
                $ctx->restore($localvars);
                return '';
            }
        }

        $blog = $ctx->mt->db()->fetch_blog($blog_id);
        $ctx->stash('blog', $blog);
        $ctx->stash('blog_id', $blog_id);
    } else {
        $repeat = false;
    }

    if (!$repeat)
        $ctx->restore($localvars);
    return $content;
}
}
?>