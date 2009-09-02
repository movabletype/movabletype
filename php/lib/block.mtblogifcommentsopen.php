<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtblogifcommentsopen.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtblogifcommentsopen($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if ($ctx->mt->config('AllowComments') &&
            (($blog->blog_allow_reg_comments && $blog->blog_commenter_authenticators)
             || $blog->blog_allow_unreg_comments))
            $open = 1;
        else
            $open = 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $open);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
