<?php
# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitelanguage($args, &$ctx) {
    require_once('function.mtbloglanguage.php');
    return smarty_function_mtbloglanguage($args, $ctx);
}
?>
