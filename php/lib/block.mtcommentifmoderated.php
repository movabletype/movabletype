<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcommentifmoderated($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        if ($comment)
            $ret = $comment->visible;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ret);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
