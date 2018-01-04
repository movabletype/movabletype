<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcategoryifallowpings($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $cat = $ctx->stash('category');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $cat->category_allow_pings > 0);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>