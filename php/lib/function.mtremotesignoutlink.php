<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtremotesignoutlink($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $static_arg;
    if (isset($args['no_static']) && ($args['no_static'] == 1)) {
        $static_arg = '';
    } else {
        $url = $args['static'];
        if (isset($url) && ($url != '1')) {
            $static_arg = "&amp;static=" . urlencode($url);
        } else if (isset($url) && ($url == 1)) {
            $static_arg = "&amp;static=1";
        } else {
            $static_arg = "&amp;static=0";
        }
    }

    $path = $path . $ctx->mt->config('CommentScript') .
        '?__mode=handle_sign_in' .
        $static_arg .
        '&amp;logout=1';
    if ($entry) {
        $path .= '&amp;entry_id=' . $entry->entry_id;
    }
    return $path;
}
?>
