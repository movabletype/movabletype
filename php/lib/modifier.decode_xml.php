<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_decode_xml($text) {
    require_once("MTUtil.php");
    return decode_xml($text);
}
?>
