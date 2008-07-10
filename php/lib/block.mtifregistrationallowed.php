<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifregistrationallowed($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $allowed = $blog['blog_allow_reg_comments'] && $blog['blog_commenter_authenticators'];
        if ($args['type'])
            $allowed = in_array(strtolower($args['type']),
                preg_split('/,/', strtolower($blog['blog_commenter_authenticators'])));
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $allowed);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
