<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("block.mtifcategory.php");
function smarty_block_mtentryifcategory($args, $content, &$ctx, &$repeat) {
    return smarty_block_mtifcategory($args, $content, $ctx, $repeat);
}
?>
