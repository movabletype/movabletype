<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifcommentsaccepted($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_accepted = (($blog['blog_allow_unreg_comments'] || 
                   ($blog['blog_allow_reg_comments']
                && $blog['blog_commenter_authenticators']))
               && $ctx->mt->config('AllowComments'));
        $entry = $ctx->stash('entry');
        if ($entry) {
            $accepted = $blog_accepted && $entry['entry_allow_comments'];
        } else {
            $accepted = $blog_accepted;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $accepted);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
