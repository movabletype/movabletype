<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtarchiveprevious.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once("archive_lib.php");
function smarty_block_mtarchiveprevious($args, $content, &$ctx, &$repeat) {
    return _hdlr_archive_prev_next($args, $content, $ctx, $repeat, 'archiveprevious');
}
?>
