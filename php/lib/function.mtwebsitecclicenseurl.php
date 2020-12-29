<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitecclicenseurl($args, &$ctx) {
    $blog = $ctx->stash('blog');
    if (empty($blog)) return '';
    $website = $blog->is_blog() ? $blog->website() : $blog;
    if (empty($website)) return '';
    $cc = $website->blog_cc_license;
    if (empty($cc)) return '';
    require_once("cc_lib.php");
    return cc_url($cc);
}
?>
