<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtpagesfooter.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('block.mtentriesfooter.php');
function smarty_block_mtpagesfooter($args, $content, &$ctx, &$repeat) {
    return smarty_block_mtentriesfooter($args, $content, $ctx, $repeat);
}
?>
