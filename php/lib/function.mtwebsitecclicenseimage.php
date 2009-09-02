<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtwebsitecclicenseimage.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_function_mtwebsitecclicenseimage($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogcclicenseimage.php');
    return smarty_function_mtblogcclicenseimage($args, $ctx);
}
?>
