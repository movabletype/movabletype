<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_encode_xml($text) {
    require_once("MTUtil.php");
    return encode_xml($text);
}
?>
