<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtproductname($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $short_name = PRODUCT_NAME;
    if ($args['version']) {
        return $ctx->mt->translate("[_1] [_2]", array($short_name, VERSION_ID));
    } else {
        return $short_name;
    }
}
?>
