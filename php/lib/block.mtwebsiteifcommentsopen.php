<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtwebsiteifcommentsopen($args, $content, &$_smarty_tpl, &$repeat) {
    $ctx =& $_smarty_tpl->smarty;
    // status: complete
    // parameters: none
    require_once('block.mtblogifcommentsopen.php');
    return smarty_block_mtblogifcommentsopen($args, $content, $_smarty_tpl, $repeat);
}
?>
