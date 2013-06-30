<?php
# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitefileextension($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogfileextension.php');
    return smarty_function_mtblogfileextension($args, $ctx);
}
?>
