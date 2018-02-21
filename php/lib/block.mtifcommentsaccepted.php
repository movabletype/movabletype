<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifcommentsaccepted($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_accepted = (($blog->blog_allow_unreg_comments || 
                   ($blog->blog_allow_reg_comments
                && $blog->blog_commenter_authenticators))
               && $ctx->mt->config('AllowComments'));
        $entry = $ctx->stash('entry');
        if ($entry) {
            $accepted = $blog_accepted && $entry->entry_allow_comments;
        } else {
            $accepted = $blog_accepted;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $accepted);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
