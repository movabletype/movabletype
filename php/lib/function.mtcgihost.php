<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcgihost($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    if (preg_match('/^https?:\/\/([^\/:]+)(:\d+)?\//', $path, $matches))
        return $args['exclude_port'] ? $matches[1] : $matches[1] . $matches[2];
    return '';
}
?>
