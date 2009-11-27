<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtwebsitehasblog($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if (empty($blog)) {
            $ret = false;
        } else if($blog->class == 'blog') {
            $ret = false;
        } else {
            $blogs = $blog->blogs();
            $ret = empty($blogs)
                ? false
                : true;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ret);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
