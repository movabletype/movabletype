<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_trim_to($text, $len) {
    $tail = '';
    if ( strstr( $len, '+' ) ) {
        $matches = explode( '+', $len );
        $len  = $matches[0];
        $tail = $matches[1];
    }
    $len = intval($len);
    if ( $len <= 0 ) return '';

    require_once("MTUtil.php");
    if ($len < length_text($text)) {
        $text = substr_text($text, 0, $len);
        if ( !empty( $tail ) ) {
            $text .= $tail;
        }
    }
    return $text;
}
?>
