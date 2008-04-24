<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtsignoutlink($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    if (isset($args['no_static']) && ($args['no_static'] == 1)) {
        $static_arg = '';
    } else {
        $url = $args['static'];
        if (isset($url) && ($url != '1')) {
            $static_arg = "&static=" . urlencode($url);
        } else if (isset($url) && ($url == 1)) {
            $static_arg = "&static=1";
        } else {
            $static_arg = "&static=0";
        }
    }

    $path = $path . $ctx->mt->config('CommentScript') .
        '?__mode=handle_sign_in' .
        $static_arg .
        '&logout=1';
    if ($entry) {
        $path .= '&entry_id=' . $entry['entry_id'];
    }
    return $path;
}
