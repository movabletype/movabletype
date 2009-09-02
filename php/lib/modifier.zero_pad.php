<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: modifier.zero_pad.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_modifier_zero_pad($text, $len) {
    return sprintf("%0".$len."s", $text);
}
?>
