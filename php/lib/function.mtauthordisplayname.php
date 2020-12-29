<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $author = $ctx->stash('author');
    if (empty($author)) {
        $entry = $ctx->stash('entry');
        if (!empty($entry)) {
            $author = $entry->author();
        }
    }
    if (empty($author)) {
        return $ctx->error("No author available");
    }
    $author_name = $author->author_nickname;
    $author_name or $author_name =
        $ctx->mt->translate('(Display Name not set)');
    return $author_name;
}
?>
