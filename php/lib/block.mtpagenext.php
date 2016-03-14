<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mtentrynext.php');
function smarty_block_mtpagenext($args, $content, &$_smarty_tpl, &$repeat) {
    $ctx =& $_smarty_tpl->smarty;
    $args['class'] = 'page';
    return smarty_block_mtentrynext($args, $content, $_smarty_tpl, $repeat);
}
?>
