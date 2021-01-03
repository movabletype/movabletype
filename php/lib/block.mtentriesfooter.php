<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentriesfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entries = $ctx->stash('entries');
        $counter = $ctx->stash('_entries_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, (is_array($entries) && $counter == count($entries)));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
