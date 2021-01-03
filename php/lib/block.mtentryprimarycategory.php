<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentryprimarycategory($args, $content, &$ctx, &$repeat) {
    $localvars = array( 'category' );
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        $cat = $entry->category();
        if ( empty( $cat ) ) { $repeat = false; return ''; }
        $ctx->stash('category', $cat);
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
