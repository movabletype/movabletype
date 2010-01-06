<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtentryifallowpings($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entry = $ctx->stash('entry');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $entry['entry_allow_pings'] > 0);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>