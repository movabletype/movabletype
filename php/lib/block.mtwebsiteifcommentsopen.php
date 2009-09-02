<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtwebsiteifcommentsopen.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_block_mtwebsiteifcommentsopen($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    require_once('block.mtblogifcommentsopen.php');
    return smarty_block_mtblogifcommentsopen($args, $content, $ctx, $repeat);
}
?>
