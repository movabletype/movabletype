<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtsubcategorypath.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtsubcategorypath($args, &$ctx) {
    require_once("block.mtparentcategories.php");
    require_once("function.mtcategorybasename.php");

    $bargs = array();
    if (isset($args['separator']))
        $bargs['separator'] = $args['separator'];

    $args = array('glue' => '/');
    $content = null;
    $repeat = true;
    smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    $res = '';

    while ($repeat) {
        $content = smarty_function_mtcategorybasename($bargs, $ctx);
        $res .= smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    }
    return $res;
}
?>
