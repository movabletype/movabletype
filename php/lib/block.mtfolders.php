<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtfolders.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('block.mtcategories.php');
function smarty_block_mtfolders($args, $content, &$ctx, &$repeat) {
    // status: incomplete
    // parameters: show_empty
    $args['class'] = 'folder';
    return smarty_block_mtcategories($args, $content, $ctx, $repeat);
}
?>
