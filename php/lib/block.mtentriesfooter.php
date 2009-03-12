<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtentriesfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entries =& $ctx->stash('entries');
        $counter = $ctx->stash('_entries_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $counter == count($entries));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
