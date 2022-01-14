<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtauthorbasename($args, &$ctx) {
    $author = $ctx->stash('author');
    if (!$author) return '';
    $basename = $author->author_basename;
    if ($sep = (isset($args['separator']) ? $args['separator'] : null)) {
        if ($sep == '-') {
            $basename = preg_replace('/_/', '-', $basename);
        } elseif ($sep == '_') {
            $basename = preg_replace('/-/', '_', $basename);
        }
    }
    return $basename;
}
?>
