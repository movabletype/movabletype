<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtsiteslocalsite($args, $content, &$ctx, &$repeat) {
    $localvars = array('local_blog_id', 'blog_id', 'blog');
    if (!isset($content)) {
        $blog_id = $ctx->stash('blog_id');
        $local_blog_id = $ctx->stash('local_blog_id');
        if ($local_blog_id) {
            $ctx->localize($localvars);
            $blog = $ctx->mt->db()->fetch_blog($local_blog_id);
            $ctx->stash('blog_id', $local_blog_id);
            $ctx->stash('blog', $blog);
        }
    } else {
        $repeat = false;
    }

    if (!$repeat)
        $ctx->restore($localvars);
    return $content;
}
?>
