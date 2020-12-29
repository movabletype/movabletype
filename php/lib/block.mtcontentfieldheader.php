<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcontentfieldheader($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ctx->localize(array('conditional', 'else_content'));
        $ctx->stash('conditional', $ctx->stash('ContentFieldHeader') == 1);
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('conditional', 'else_content'));
    }
    return $content;
}
?>
