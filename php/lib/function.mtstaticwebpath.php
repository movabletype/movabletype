<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtstaticwebpath.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_function_mtstaticwebpath($args, &$ctx) {
    $path = $ctx->mt->config('StaticWebPath');
    if (!$path) {
        require_once "function.mtcgipath.php";
        $path = smarty_function_mtcgipath($args, $ctx);
        $path .= 'mt-static/';
    } elseif (substr($path, 0, 1) == '/') {
        $blog = $ctx->stash('blog');
        $host = $blog->site_url();
        if (!preg_match('!/$!', $host))
            $host .= '/';
        if (preg_match('!^(https?://[^/:]+)(:\d+)?/!', $host, $matches)) {
            $path = $matches[1] . $path;
        }        
    }
    if (substr($path, strlen($path) - 1, 1) != '/')
        $path .= '/';
    return $path;
}
?>
