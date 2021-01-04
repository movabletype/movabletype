<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mtentrydate.php');
function smarty_function_mtpagedate($args, &$ctx) {
    return smarty_function_mtentrydate($args, $ctx);
}
?>
