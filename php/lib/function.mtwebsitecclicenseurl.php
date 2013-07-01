<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
