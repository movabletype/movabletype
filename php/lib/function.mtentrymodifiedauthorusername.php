<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrymodifiedauthorusername($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    return $entry->modified_author()->name;
}
?>
