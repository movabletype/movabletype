<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtsetvars($args, $content, &$ctx, &$repeat) {
    // parameters: name, value
    if (isset($content)) {
        $vars =& $ctx->__stash['vars'];
        if (!is_array($vars)) {
            $vars = array();
            $ctx->__stash['vars'] = $vars;
        }
        $pairs = preg_split('/\r?\n/', trim($content));
        foreach ($pairs as $line) {
            list($var, $value) = preg_split('/\s*=/', $line, 2);
            if (isset($var) && isset($value)) {
                $vars[trim($var)] = $value;
            }
        }
    }
    return '';
}
?>
