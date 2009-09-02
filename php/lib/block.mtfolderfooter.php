<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtfolderfooter.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtfolderfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $categories =& $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');

        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 
                              ((isset($counter) && isset($categories)) && $counter == count($categories) || $ctx->stash('subFolderFoot'))
        );
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
