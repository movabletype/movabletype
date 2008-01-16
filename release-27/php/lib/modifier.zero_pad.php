<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_zero_pad($text, $len) {
    return sprintf("%0".$len."s", $text);
}
?>
