<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifcurrentpage($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $limit = $ctx->stash('__pager_limit');
        $offset = $ctx->stash('__pager_offset');
        $value = $ctx->__stash['vars']['__value__'];
        $current = $limit ? $offset / $limit + 1 : 1;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $value == $current);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
