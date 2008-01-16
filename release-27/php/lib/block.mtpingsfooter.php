<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtpingsfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $pings = $ctx->stash('_pings');
        $counter = $ctx->stash('_pings_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $counter == count($pings));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
