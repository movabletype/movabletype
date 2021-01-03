<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtsigninlink($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $entry = $ctx->stash('entry');
    $static_arg = $args['static'] ? "&static=1" : "&static=0";

    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $return = $path . $ctx->mt->config('CommentScript') .
        '?__mode=login' . $static_arg;
    if ($blog)
        $return .= '&blog_id=' . $blog->blog_id;
    if ($entry)
        $return .= '&entry_id=' . $entry->entry_id;
    return $return;
}
?>
