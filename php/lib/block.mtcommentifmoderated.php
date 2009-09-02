<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtcommentifmoderated.php 106007 2009-07-01 11:33:43Z ytakayama $

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
