<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_wrap_text($text, $words) {
    return wordwrap($text, $words - 1, "\n", true);
}
?>
