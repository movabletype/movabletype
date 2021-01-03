<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_encode_url($text) {
    $text = urlencode($text);
    $text = preg_replace('/\+/', '%20', $text);
    return $text;
}
?>
