<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: modifier.sanitize.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_modifier_sanitize($text, $spec = '1') {
    if ($spec == '1') {
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
