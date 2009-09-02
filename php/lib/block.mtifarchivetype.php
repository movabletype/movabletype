<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtifarchivetype.php 106007 2009-07-01 11:33:43Z ytakayama $

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
