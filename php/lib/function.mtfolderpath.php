<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mtsubcategorypath.php');
function smarty_function_mtfolderpath($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $args['class'] = 'folder';
    return smarty_function_mtsubcategorypath($args, $_smarty_tpl);
}
?>
