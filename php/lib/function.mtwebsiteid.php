<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsiteid($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    if (empty($blog)) return 0;
    $website = $blog->is_blog() ? $blog->website() : $blog;
    if (empty($website)) return '';
    return $website->id;
}
?>
