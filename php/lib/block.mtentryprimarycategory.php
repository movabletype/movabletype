<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
