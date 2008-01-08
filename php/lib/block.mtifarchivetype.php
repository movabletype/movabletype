<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifarchivetype($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $at = $args['type'];
        $at or $at = $args['archive_type'];
        $cat = $ctx->stash('current_archive_type');
        $cat or $at = $ctx->stash('archive_type');
        $same = ($at && $cat) && ($at == $cat);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $same);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
