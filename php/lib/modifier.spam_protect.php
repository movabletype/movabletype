<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_spam_protect($text, $value) {
    # defined in mt.php itself
    if (isset($value) && $value) {
        return spam_protect($text);
    } else {
        return $text;
    }
}
?>
