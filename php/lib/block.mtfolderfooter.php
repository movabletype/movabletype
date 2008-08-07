<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

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
