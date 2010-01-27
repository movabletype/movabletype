<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtwebsitehost($args, &$ctx) {
    // status: complete
    // parameters: exclude_port, signature
    require_once('function.mtbloghost.php');
    return smarty_function_mtbloghost($args, $ctx);
}
?>
