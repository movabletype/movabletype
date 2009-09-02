<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtmultiblogiflocalblog.php 108527 2009-08-06 05:08:54Z ytakayama $

if (MULTIBLOG_ENABLED) {
function smarty_block_mtmultiblogiflocalblog($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog_id = $ctx->stash('blog_id');
        $local_blog_id = $ctx->stash('local_blog_id');
        if (! isset($local_blog_id)) $local_blog_id = $blog_id;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat,
            $local_blog_id == $blog_id);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
}
?>