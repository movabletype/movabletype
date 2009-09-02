<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtpings.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtpings($args, $content, &$ctx, &$repeat) {
    $localvars = array('ping', '_pings', '_pings_counter', 'current_timestamp', 'blog_id', 'blog');
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
