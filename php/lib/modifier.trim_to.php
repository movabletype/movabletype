<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("MTUtil.php");

function smarty_modifier_trim_to($text, $len) {
    $tail = '';
    if ( strstr( $len, '+' ) ) {
        $matches = explode( '+', $len );
        $len  = $matches[0];
        $tail = $matches[1];
    }
    $len = intval($len);

    if ( $len > 0 ) {

        # $len is positive number
        if ($len < length_text($text)) {
            $text = substr_text($text, 0, $len);
            if ( !is_null( $tail ) && $tail !== "" ) {
                $text .= $tail;
            }
        }
        return $text;

    } elseif ( $len < 0 ) {

        # $len is negative number.
        $text = substr_text($text, 0, $len);
        if ( !is_null( $text ) && $text !== ""
            && !is_null( $tail ) && $tail !== "" ) {
            $text .= $tail;
        }
        return $text;

    }

    # $len is zero or is not number.
    return '';
}
?>
