<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("archive_lib.php");
function smarty_block_mtarchivenext($args, $content, &$ctx, &$repeat) {
    return _hdlr_archive_prev_next($args, $content, $ctx, $repeat, 'archivenext');
}
?>
