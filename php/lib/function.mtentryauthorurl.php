<?php
# Movable Type (r) (C) 2001-2020 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentryauthorurl($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry->author()->url;
}
?>
