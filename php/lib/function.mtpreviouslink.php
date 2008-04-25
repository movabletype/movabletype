<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtpreviouslink($args, &$ctx) {
    $limit = $ctx->stash('__pager_limit');
    $offset = $ctx->stash('__pager_offset');

    if ( $offset <= $limit )
        $offset = 0;
    else
        $offset -= $limit;

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

