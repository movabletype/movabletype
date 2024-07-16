<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtscript($args, &$ctx) {
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
    $script_path = $static_path . $file_path;
    $type  = $args["type"] ? ' type="' . $args["type"] . '"' : '';
    $async = $args["async"] == '1' ? ' async' : '';
    $defer = $args["defer"] == '1' ? ' defer' : '';
    $version = urlencode(VERSION_ID);
    $version = preg_replace('/\+/', '%20', $version);

    return sprintf('<script src="%s?v=%s"%s%s%s></script>', $script_path, $version, $type, $async, $defer);
}
?>
