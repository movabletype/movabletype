<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtblogcclicenseurl($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $cc = $blog['blog_cc_license'];
    if (empty($cc)) return '';
    require_once("cc_lib.php");
    return cc_url($cc);
}
?>
