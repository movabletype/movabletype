<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_numify($text, $attr = ',') {
    if ($attr == "1") $attr = ',';
    $attr = str_replace(array('\\', '$'), array('\\\\', '\$'), $attr);
    return preg_replace('/(^[-+]?\d+?(?=(?>(?:\d{3})+)(?!\d))|\G\d{3}(?=\d))/', '${1}' . $attr, $text);
}
?>
