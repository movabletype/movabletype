<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtincludeblock($args, $content, &$_smarty_tpl, &$repeat) {
    $ctx =& $_smarty_tpl->smarty;
    if (!isset($content)) {
    } else {
        require_once("function.mtinclude.php");
        $vars =& $ctx->__stash['vars'];
        if (!$vars) {
            $vars = array();
            $ctx->__stash['vars'] =& $vars;
        }
        $name = $args['var'];
        $name or $name = 'contents';
        $oldval = $vars[$name];

        $vars[$name] = $args['token_fn'];
        $content = smarty_function_mtinclude($args, $_smarty_tpl);
        $vars[$name] = $oldval;
    }
    return $content;
}
?>
