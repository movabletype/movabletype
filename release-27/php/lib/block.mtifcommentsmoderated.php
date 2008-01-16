<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifcommentsmoderated($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $moderated = ($blog['blog_moderate_unreg_comments'] || $blog['blog_manual_approve_commenters']);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $moderated);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
