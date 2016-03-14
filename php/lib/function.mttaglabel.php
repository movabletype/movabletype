<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mttagname.php');
function smarty_function_mttaglabel($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    return smarty_function_mttagname($args, $_smarty_tpl);
}
?>
