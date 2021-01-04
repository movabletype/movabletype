<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("archive_lib.php");
function smarty_block_mtcontentprevious($args, $res, &$ctx, &$repeat) {
    $localvars = array('content', 'conditional', 'else_content');

    if (!isset($res)) {
        $ctx->localize($localvars);
        $content = $ctx->stash('content');
        if ($content) {
            $previous_content = $ctx->mt->db()->fetch_next_prev_content('previous', $args);
            $ctx->stash('content', $previous_content);
        }
        if (isset($previous_content)) {
            $ctx->stash('conditional', true);
            $ctx->stash('else_content', null);
        } else {
            $ctx->restore($localvars);
            $repeat = false;
        }
    } else {
        if (!$ctx->stash('conditional')) {
            $res = $ctx->stash('else_content');
        }
        $ctx->restore($localvars);
    }
    return $res;
}
?>
