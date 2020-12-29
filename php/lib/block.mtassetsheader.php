<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtassetsheader($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $counter = $ctx->stash('_assets_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $counter == 1);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
