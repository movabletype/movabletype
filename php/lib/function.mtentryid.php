<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentryid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) {
        if ($ctx->stash('content')) {
            require_once('function.mtcontentid.php');
            return smarty_function_mtcontentid($args, $ctx);
        }
        return;
    }
    return (isset($args['pad']) && $args['pad']) ? sprintf("%06d", $entry->entry_id) : $entry->entry_id;
}
?>
