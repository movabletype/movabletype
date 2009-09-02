<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: modifier.setvar.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_modifier_setvar($text, $name) {
    $mt = MT::get_instance();
    $ctx =& $mt->context();
    if (array_key_exists('__inside_set_hashvar', $ctx->__stash)) {
        $vars =& $ctx->__stash['__inside_set_hashvar'];
    } else {
        $vars =& $ctx->__stash['vars'];
    }
    $vars[$name] = $text;
    return '';
}
