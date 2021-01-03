<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtwebsiteifcclicense($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if (empty($blog)) return 0;
        $website = $blog->is_blog() ? $blog->website() : $blog;
        if (empty($website)) return '';
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, !empty($website->blog_cc_license));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
