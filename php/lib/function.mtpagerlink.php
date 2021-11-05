<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtpagerlink($args, &$ctx) {
    $page = $ctx->__stash['vars']['__value__'];
    if ( !$page ) return '';

    $limit = $ctx->stash('__pager_limit');
    $offset = ( $page - 1 ) * $limit;

    $link = '';
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
