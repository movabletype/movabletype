<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
