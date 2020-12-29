<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("archive_lib.php");
function smarty_block_mtarchivenext($args, $content, &$ctx, &$repeat) {
    $mt = MT::get_instance();
    if (isset($args['content_type'])) {
        $content_types = $mt->db()->fetch_content_types(array('content_type' => $args['content_type']));
        $content_type = $content_types[0];
        $ctx->stash('content_type', $content_type);
    }
    return _hdlr_archive_prev_next($args, $content, $ctx, $repeat, 'archivenext');
}
?>
