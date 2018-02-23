<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifpingsaccepted($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $entry = $ctx->stash('entry');
        $blog_accepted = $blog->blog_allow_pings && $ctx->mt->config('AllowPings');
        if ($entry) {
            $accepted = $blog_accepted && $entry->entry_allow_pings;
        } else {
            $accepted = $blog_accepted;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $accepted);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
