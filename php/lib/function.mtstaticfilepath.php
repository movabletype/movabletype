<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
