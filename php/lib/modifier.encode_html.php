<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_encode_html($text) {
    if (version_compare(phpversion(), '4.3.0', '>=')) {
        $mt = MT::get_instance();
        $charset = $mt->config('PublishCharset');
        return htmlentities($text, ENT_COMPAT, $charset);
    } else {
        return htmlentities($text, ENT_COMPAT);
    }
}
?>
