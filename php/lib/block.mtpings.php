<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtpings($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('ping', '_pings', '_pings_counter', 'current_timestamp', 'blog_id', 'blog'), common_loop_vars());
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        if (isset($entry))
            $args['entry_id'] = $entry->entry_id;
        $blog = $ctx->stash('blog');
        if ($blog)
            $args['blog_id'] = $blog->blog_id;
        $pings = $ctx->mt->db()->fetch_pings($args);
        $ctx->stash('_pings', $pings);
        $counter = 0;
    } else {
        $pings = $ctx->stash('_pings');
        $counter = $ctx->stash('_pings_counter');
    }
    if ($counter < count($pings)) {
        $blog_id = $ctx->stash('blog_id');
        $ping = $pings[$counter];
        if (!empty($ping)) {
            if ($blog_id != $ping->tbping_blog_id) {
                $blog_id = $ping->tbping_blog_id;
                $ctx->stash('blog_id', $blog_id);
                $ctx->stash('blog', $ping->blog());
            }
            $ctx->stash('ping', $ping);
            $ctx->stash('current_timestamp', $ping->tbping_created_on);
            $ctx->stash('_pings_counter', $counter + 1);
            $repeat = true;
            $count = $counter + 1;
            $ctx->__stash['vars']['__counter__'] = $count;
            $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
            $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
            $ctx->__stash['vars']['__first__'] = $count == 1;
            $ctx->__stash['vars']['__last__'] = ($count == count($pings));
        }
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
