<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtsigninlink($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $entry = $ctx->stash('entry');
    $static_arg = $args['static'] ? "&static=1" : "&static=0";

    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $return = $path . $ctx->mt->config('CommentScript') .
        '?__mode=login' . $static_arg;
    if ($blog)
        $return .= '&blog_id=' . $blog['blog_id'];
    if ($entry)
        $return .= '&entry_id=' . $entry['entry_id'];
    return $return;
}
