<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
