<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_setvar($text, $name) {
    global $mt;
    $ctx =& $mt->context();
    if (array_key_exists('__inside_set_hashvar', $ctx->__stash)) {
        $vars =& $ctx->__stash['__inside_set_hashvar'];
    } else {
        $vars =& $ctx->__stash['vars'];
    }
    $vars[$name] = $text;
    return '';
}
