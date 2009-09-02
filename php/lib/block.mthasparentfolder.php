<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mthasparentfolder.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('block.mthasparentcategory.php');
function smarty_block_mthasparentfolder($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mthasparentcategory($args, $content, $ctx, $repaet);
}
?>
