<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentryauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    if ( !empty($entry) ) {
        $author = $entry->author()->nickname;
        return $author;
    } else {
        return '';
    }
}
?>
