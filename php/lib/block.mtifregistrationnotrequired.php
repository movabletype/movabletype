<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifregistrationnotrequired($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat,
                              ($blog->blog_allow_reg_comments &&
                               $blog->blog_commenter_authenticators &&
                               $blog->blog_allow_unreg_comments));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
