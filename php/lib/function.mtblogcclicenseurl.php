<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtblogcclicenseurl.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtblogcclicenseurl($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $cc = $blog->blog_cc_license;
    if (empty($cc)) return '';
    require_once("cc_lib.php");
    return cc_url($cc);
}
?>
