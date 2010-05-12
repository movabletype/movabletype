<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcommenteriftrusted($args, $content, &$ctx, &$repeat) {
    require_once('block.mtifcommentertrusted.php');
    return smarty_block_mtifcommentertrusted($args, $content, $ctx, $repeat);
}
?>
