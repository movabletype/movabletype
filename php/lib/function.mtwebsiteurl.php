<?php
# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsiteurl($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogurl.php');
    return smarty_function_mtblogurl($args, $ctx);
}
?>
