<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtsetvartemplate.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtsetvartemplate($args, $content, &$ctx, &$repeat) {
    // parameters: name, value
    if (!isset($content)) {
        $name = $args['name'];
        $name or $name = $args['var'];
        if (!$name) return '';
        $value = $args['token_fn'];
        $vars =& $ctx->__stash['vars'];
        if (is_array($vars)) {
            $vars[$name] = $value;
        } else {
            $vars = array($name => $value);
            $ctx->__stash['vars'] =& $vars;
        }
    }
    return '';
}
?>
