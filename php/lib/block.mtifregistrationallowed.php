<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifregistrationallowed($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $allowed = $blog->blog_allow_reg_comments && $blog->blog_commenter_authenticators;
        if ($args['type'])
            $allowed = in_array(strtolower($args['type']),
                preg_split('/,/', strtolower($blog->blog_commenter_authenticators)));
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $allowed);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
