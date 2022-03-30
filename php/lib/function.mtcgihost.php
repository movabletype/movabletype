<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcgihost($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    if (preg_match('/^https?:\/\/([^\/:]+)(:\d+)?\//', $path, $matches))
        return !empty($args['exclude_port']) ? $matches[1] : $matches[1] . (isset($matches[2]) ? $matches[2] : '');
    return '';
}
?>
