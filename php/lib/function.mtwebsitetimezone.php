<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtwebsitetimezone($args, &$ctx) {
    // status: complete
    // parameters: no_colon
    require_once('function.mtblogtimezone.php');
    return smarty_function_mtblogtimezone($args, $ctx);
}
?>
