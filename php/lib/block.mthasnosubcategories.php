<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mthasnosubcategories.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once("block.mthassubcategories.php");
function smarty_block_mthasnosubcategories($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $has_no_sub_cats = !_has_sub_categories($ctx);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_no_sub_cats);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
