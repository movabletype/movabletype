<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtwebsitelabel.php 4196 2009-09-04 07:46:50Z takayama $

function smarty_function_mtwebsitethemeid($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogthemeid.php');
    return smarty_function_mtblogthemeid($args, $ctx);
}
?>
