<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtwebsitename($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogname.php');
    return smarty_function_mtblogname($args, $ctx);
}
?>
