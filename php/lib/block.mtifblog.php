<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtifblog.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_block_mtifblog($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $ok = empty($blog)
            ? 0
            : $blog->class == 'blog'
                ? 1
                : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ok);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
