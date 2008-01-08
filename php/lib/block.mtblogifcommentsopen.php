<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtblogifcommentsopen($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if ($ctx->mt->config('AllowComments') &&
            (($blog['blog_allow_reg_comments'] && $blog['blog_commenter_authenticators'])
             || $blog['blog_allow_unreg_comments']))
            $open = 1;
        else
            $open = 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $open);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
