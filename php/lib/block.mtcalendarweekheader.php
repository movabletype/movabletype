<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtcalendarweekheader.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtcalendarweekheader($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 'CalendarWeekHeader');
}
?>
