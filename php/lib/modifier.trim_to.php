<?php
# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
