<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtcommentsfooter.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtcommentsfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $comments = $ctx->stash('comments');
        $counter = $ctx->stash('comment_order_num');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $counter == count($comments));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
