<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtblogs($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('_blogs', '_blogs_counter', 'blog', 'blog_id'), common_loop_vars());

    if (!isset($content)) {
        $ctx->localize($localvars);
        if (!(
            isset($args['include_blogs']) ||
            isset($args['include_websites']) ||
            isset($args['blog_ids']) ||
            isset($args['site_ids']) ||
            isset($args['blog_id']) # in smarty_block_mtblogparentwebsite
        )) {
            $args['include_blogs'] = 'all';
        }
        $blogs = $ctx->mt->db()->fetch_blogs($args);
        $ctx->stash('_blogs', $blogs);
        $counter = 0;
    } else {
        $blogs = $ctx->stash('_blogs');
        $counter = $ctx->stash('_blogs_counter');
    }
    if ($counter < count($blogs)) {
        $blog = $blogs[$counter];
        $ctx->stash('blog', $blog);
        $ctx->stash('blog_id', $blog->blog_id);
        $ctx->stash('_blogs_counter', $counter + 1);
        $count = $counter + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($blogs));
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
