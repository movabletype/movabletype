<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtstylesheet($args, &$ctx) {
    $static_path = $ctx->mt->config('StaticWebPath');
    if (!$static_path) {
        require_once "function.mtcgipath.php";
        $static_path = smarty_function_mtcgipath($args, $ctx);
        $static_path .= 'mt-static/';
    } elseif (substr($static_path, 0, 1) != '/') {
        $static_path .= '/';
    }

    $file_path = $args['name'] ?? '';
    $file_path = ltrim($file_path, '/');
    $stylesheet_path = $static_path . $file_path;
    $version = urlencode(VERSION_ID);
    $version = preg_replace('/\+/', '%20', $version);

    return sprintf('<link rel="stylesheet" href="%s?v=%s">', $stylesheet_path, $version);
}
?>
