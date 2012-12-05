<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtincludeblock($args, $content, &$ctx, &$repeat) {
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
        $content = smarty_function_mtinclude($args, $ctx);
        $vars[$name] = $oldval;
    }
    return $content;
}
?>
