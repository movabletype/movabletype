<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtstylesheet($args, &$ctx) {
    $path = $args['path'];
    if (!isset($path)) {
      return $ctx->error($ctx->mt->translate('path is required.'));
    }
    $version = VERSION_ID;

    $static_path = $ctx->mt->config('StaticWebPath');
    if (!$static_path) {
        require_once "function.mtcgipath.php";
        $static_path = smarty_function_mtcgipath($args, $ctx);
        $static_path .= 'mt-static/';
    } elseif (substr($static_path, 0, 1) != '/') {
        $static_path .= '/';
    }

    if (strpos($path, '%l') !== false) {
        $lang_id = strtolower($ctx->mt->config('DefaultLanguage')) ?? 'en_us';
        $lang_id = str_replace('-', '_', $lang_id);
        $path = str_replace('%l', $lang_id, $path);
    }
    $path = ltrim($path, '/');
    $stylesheet_path = $static_path . encode_html($path);

    return sprintf('<link rel="stylesheet" href="%s?v=%s">', $stylesheet_path, $version);
}
?>
