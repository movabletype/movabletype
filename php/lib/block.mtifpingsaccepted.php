<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtifpingsaccepted.php 106007 2009-07-01 11:33:43Z ytakayama $

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
