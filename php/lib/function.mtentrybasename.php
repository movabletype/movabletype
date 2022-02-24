<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrybasename($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry && $ctx->stash('content')) {
        require_once('function.mtcontentidentifier.php');
        return smarty_function_mtcontentidentifier($args, $ctx);
    }
    if (!$entry) return '';
    $basename = $entry->entry_basename;
    if ($sep = isset($args['separator']) ? $args['separator'] : null) {
        if ($sep == '-') {
            $basename = preg_replace('/_/', '-', $basename);
        } elseif ($sep == '_') {
            $basename = preg_replace('/-/', '_', $basename);
        }
    }
    return $basename;
}
?>
