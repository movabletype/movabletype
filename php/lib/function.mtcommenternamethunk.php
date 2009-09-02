<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcommenternamethunk.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtcommenternamethunk($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $archive_url = $ctx->tag('BlogArchiveURL');
    if (preg_match('|://([^/]*)|', $archive_url, $matches)) {
        $blog_domain = $matches[1];
    }
    require_once "function.mtcgipath.php";
    $cgi_path = smarty_function_mtcgipath($args, $ctx);
    $mt_domain = $cgi_path;
    if (preg_match('|://([^/]*)|', $mt_domain, $matches)) {
        $mt_domain = $matches[1];
    }
    if ($blog_domain != $mt_domain) {
        $cmt_script = $ctx->mt->config('CommentScript');
        return "<script type='text/javascript' src='$cgi_path$cmt_script?__mode=cmtr_name_js'></script>";
    } else {
        return "<script type='text/javascript'>var commenter_name = getCookie('commenter_name')</script>";
    }
}
?>
