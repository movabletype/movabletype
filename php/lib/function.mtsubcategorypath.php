<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtsubcategorypath($args, &$ctx) {
    require_once("block.mtparentcategories.php");
    require_once("function.mtcategorylabel.php");
    require_once("modifier.dirify.php");

    $args = array('glue' => '/');
    $content = null;
    $repeat = true;
    smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    $res = '';
    while ($repeat) {
        $content = smarty_function_mtcategorylabel(array(), $ctx);
        $content = smarty_modifier_dirify($content, isset($args['separator']) ? $args['separator'] : '1');
        $res .= smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    }
    return $res;
}
?>
