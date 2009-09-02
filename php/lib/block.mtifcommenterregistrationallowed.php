<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtifcommenterregistrationallowed.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtifcommenterregistrationallowed($args, $content, &$ctx, &$repeat) {
    $registration = $ctx->mt->config('commenterregistration');
    $blog = $ctx->stash('blog');
    $allow = $registration['allow'] && ($blog && $blog->blog_allow_commenter_regist);
    if (!isset($content)) {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $allow);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
