<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mttotalpages($args, &$ctx) {
    $limit = $ctx->stash('__pager_limit');
    if (!$limit) return 1;
    $offset = $ctx->stash('__pager_offset');
    ceil( $count / $limit );
}
?>

