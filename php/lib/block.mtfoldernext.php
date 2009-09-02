<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtfoldernext.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('block.mtcategorynext.php');
function smarty_block_mtfoldernext($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtcategorynext($args, $content, $ctx, $repeat);
}
?>
