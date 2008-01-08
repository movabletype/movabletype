<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtstaticfilepath($args, &$ctx) {
    $path = $ctx->mt->config('StaticFilePath');
    if (!$path) {
        $path = dirname(dirname(dirname(__FILE__)));
        $path .= DIRECTORY_SEPARATOR . 'mt-static' . DIRECTORY_SEPARATOR;
    }
    if (substr($path, strlen($path) - 1, 1) != DIRECTORY_SEPARATOR)
        $path .= DIRECTORY_SEPARATOR;
    return $path;
}
?>
