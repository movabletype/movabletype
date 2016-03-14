<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcommenterauthiconurl($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $a =& $ctx->stash('commenter');
    if (!isset($a)) {
        return '';
    }
    require_once "function.mtstaticwebpath.php";
    $static_path = smarty_function_mtstaticwebpath($args, $_smarty_tpl);
    require_once "commenter_auth_lib.php";
    return _auth_icon_url($static_path, $a);
}
?>
