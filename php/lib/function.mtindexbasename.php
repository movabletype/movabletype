<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtindexbasename($args, &$ctx) {
    $name = $ctx->mt->config('IndexBasename');
    if (!isset($args['extension']) || !$args['extension']) return $name;
    $blog = $ctx->stash('blog');
    $ext = $blog->blog_file_extension;
    if ($ext) $ext = '.' . $ext;
    return $name . $ext;
}
?>
