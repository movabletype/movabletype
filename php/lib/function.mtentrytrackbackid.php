<?php
# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrytrackbackid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $tb = $entry->trackback();
    return $tb->trackback_id;
}
?>
