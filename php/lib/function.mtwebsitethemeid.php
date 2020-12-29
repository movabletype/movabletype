<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtwebsitelabel.php 4196 2009-09-04 07:46:50Z takayama $

function smarty_function_mtwebsitethemeid($args, &$ctx) {
    // status: complete
    // parameters: raw
    $blog = $ctx->stash('blog');
    if (empty($blog)) return '';
    $website = $blog->is_blog() ? $blog->website() : $blog;
    if (empty($website)) return '';
    $id = $website->blog_theme_id;
    $raw = isset($args['raw']) ? $args['raw'] : 0;
    if (!$raw)
        $id = str_replace ('_', '-', $id);
    return $id;
}
?>
