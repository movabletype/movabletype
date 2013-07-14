<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
