<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcontentsfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $contents = $ctx->stash('contents');
        $counter = $ctx->stash('_contents_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, (is_array($contents) && $counter == count($contents)));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
