<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mttotalpages($args, &$ctx) {
    $limit = $ctx->stash('__pager_limit');
    if (!$limit) return 1;
    $offset = $ctx->stash('__pager_offset');
    $count = $ctx->stash('__pager_total_count');
    return ceil( $count / $limit );
}
?>
