<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mtsubcatsrecurse.php');
function smarty_function_mtsubfolderrecurse($args, &$ctx) {
    $args['class'] = 'folder';
    return smarty_function_mtsubcatsrecurse($args, $ctx);
}
?>
