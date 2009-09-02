<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtproductname.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtproductname($args, &$ctx) {
    $short_name = PRODUCT_NAME;
    if ($args['version']) {
        return $ctx->mt->translate("[_1] [_2]", array($short_name, VERSION_ID));
    } else {
        return $short_name;
    }
}
?>
