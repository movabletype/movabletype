<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcgirelativeurl($args, &$ctx) {
    // status: complete
    // parameters: none
    $url = $ctx->mt->config('CGIPath');
    if (substr($url, strlen($url) - 1, 1) != '/')
        $url .= '/';
    if (preg_match('!^(?:https?://[^/]+)?(/.*)$!', $url, $matches)) {
        return $matches[1];
    } else {
        return $url;
    }
}
?>
