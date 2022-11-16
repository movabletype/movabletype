<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtbloglanguage($args, &$ctx) {
    $blog = $ctx->stash('blog');
    return normalize_language( 
        $blog->blog_language,
        isset($args['locale']) ? $args['locale'] : null,
        isset($args['ietf']) ? $args['ietf'] : null
    );
}
?>
