<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtwebsitetimezone.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_function_mtwebsitetimezone($args, &$ctx) {
    // status: complete
    // parameters: no_colon
    require_once('function.mtblogtimezone.php');
    return smarty_function_mtblogtimezone($args, $ctx);
}
?>
