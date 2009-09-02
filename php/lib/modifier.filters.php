<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: modifier.filters.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_modifier_filters($text,$filters) {
    // status: complete
    $mt = MT::get_instance();
    $ctx =& $mt->context();
    require_once 'MTUtil.php';
    $text = apply_text_filter($ctx, $text, $filters);

    return $text;
}
?>
