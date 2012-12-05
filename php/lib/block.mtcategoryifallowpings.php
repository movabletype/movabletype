<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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