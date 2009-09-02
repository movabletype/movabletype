<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtsigninlink.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtsigninlink($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $entry = $ctx->stash('entry');
    $static_arg = $args['static'] ? "&static=1" : "&static=0";

    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $return = $path . $ctx->mt->config('CommentScript') .
        '?__mode=login' . $static_arg;
    if ($blog)
        $return .= '&blog_id=' . $blog->blog_id;
    if ($entry)
        $return .= '&entry_id=' . $entry->entry_id;
    return $return;
}
