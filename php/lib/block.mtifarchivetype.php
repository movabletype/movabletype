<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
