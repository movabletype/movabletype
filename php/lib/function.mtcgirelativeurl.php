<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcgirelativeurl.php 106007 2009-07-01 11:33:43Z ytakayama $

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
