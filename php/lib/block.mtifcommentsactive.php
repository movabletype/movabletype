<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifcommentsactive($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_accepts_comments = ($blog['blog_allow_reg_comments'] &&
            $blog['blog_commenter_authenticators']) ||
            $blog['blog_allow_unreg_comments'];
        $blog_active = $blog_accepts_comments && $ctx->mt->config('AllowComments');
        $entry = $ctx->stash('entry');
        if ($entry) {
            $active = $entry['entry_comment_count'] > 0;
            $active or $active = $blog_active && $entry['entry_allow_comments'];
        } else {
            $active = $blog_active;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $active);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>