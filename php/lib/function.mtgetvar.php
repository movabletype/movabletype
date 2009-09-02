<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtgetvar.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtgetvar($args, &$ctx) {
    require_once("function.mtvar.php");
    return smarty_function_mtvar($args, $ctx);
}
?>
