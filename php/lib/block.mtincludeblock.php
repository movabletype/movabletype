<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtincludeblock($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
    } else {
        require_once("function.mtinclude.php");
        $vars =& $ctx->__stash['vars'];
        if (!$vars) {
            $vars = array();
            $ctx->__stash['vars'] = $vars;
        }
        $name = !empty($args['var']) ? $args['var'] : 'contents';
        $oldval = isset($vars[$name]) ? $vars[$name] : null;

        $vars[$name] = $args['token_fn'];
        $content = smarty_function_mtinclude($args, $ctx);
        $vars[$name] = $oldval;
    }
    return $content;
}
?>
