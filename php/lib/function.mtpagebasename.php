<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mtentrybasename.php');
function smarty_function_mtpagebasename($args, &$ctx) {
    return smarty_function_mtentrybasename($args, $ctx);
}
?>
