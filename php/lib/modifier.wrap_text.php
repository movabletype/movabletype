<?php
# Movable Type (r) (C) 2001-2020 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_wrap_text($text, $words) {
    return wordwrap($text, $words - 1, "\n", true);
}
?>
