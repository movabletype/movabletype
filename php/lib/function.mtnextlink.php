<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtnextlink.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtnextlink($args, &$ctx) {

    $limit = $ctx->stash('__pager_limit');
    $offset = $ctx->stash('__pager_offset');
    $offset += $limit;

    if ( strpos($link, '?') ) {
        $link .= '&';
    }
    else {
        $link .= '?';
    }

    $link .= "limit=$limit";
    if ( $offset )
        $link .= "&offset=$offset";
    return $link;
}
?>

