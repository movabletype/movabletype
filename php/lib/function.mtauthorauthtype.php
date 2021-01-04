<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtauthorauthtype($args, &$ctx) {
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
    return isset($author->author_auth_type) ? $author->author_auth_type : '';
}
?>
