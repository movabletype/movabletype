<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mterrorcode($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $err = $ctx->stash('error_code');
    return empty($err) ? '' : $err;
}
?>
