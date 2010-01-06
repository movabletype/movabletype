<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtwebsitecclicenseurl($args, &$ctx) {
    require_once('function.mtblogcclicenseurl.php');
    return smarty_function_mtblogcclicenseurl($args, $ctx);
}
?>
