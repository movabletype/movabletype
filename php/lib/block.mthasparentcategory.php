<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mthasparentcategory($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $class = isset($args) && isset($args['class']) ? $args['class'] : 'category';
        require_once("MTUtil.php");
        $cat = get_category_context($ctx, $class);
        $has_parent = $cat->category_parent;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, ($has_parent > 0 ? 1 : 0));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
