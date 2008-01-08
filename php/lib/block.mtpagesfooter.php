<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('block.mtentriesfooter.php');
function smarty_block_mtpagesfooter($args, $content, &$ctx, &$repeat) {
    return smarty_block_mtentriesfooter($args, $content, $ctx, $repeat);
}
?>
