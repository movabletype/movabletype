<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_numify($text, $attr = ',') {
    if ($attr == "1") $attr = ',';
    return preg_replace('/(^[−+]?\d+?(?=(?>(?:\d{3})+)(?!\d))|\G\d{3}(?=\d))/', '\\1' . $attr, $text);
}
