<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_sanitize($text, $spec = '1') {
    if (! $spec) {
        return $text;
    }
    else if ($spec == '1') {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $blog = $ctx->stash('blog');
        $spec = $blog->blog_sanitize_spec;
        $spec or $spec = $mt->config('GlobalSanitizeSpec');
    }
    require_once("sanitize_lib.php");
    return sanitize($text, $spec);
}
?>
