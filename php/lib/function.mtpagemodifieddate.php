<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mtentrymodifieddate.php');
function smarty_function_mtpagemodifieddate($args, &$ctx) {
    return smarty_function_mtentrymodifieddate($args, $ctx);
}
?>
