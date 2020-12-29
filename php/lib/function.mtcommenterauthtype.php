<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcommenterauthtype($args, &$ctx) {
    $a =& $ctx->stash('commenter');
    return isset($a) ? $a->author_auth_type : '';
}
?>
