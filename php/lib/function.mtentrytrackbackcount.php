<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrytrackbackcount($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $count = $entry->entry_ping_count;
    return $ctx->count_format($count, $args);
}
?>
