<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtpagedate.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('function.mtentrydate.php');
function smarty_function_mtpagedate($args, &$ctx) {
    return smarty_function_mtentrydate($args, $ctx);
}
?>
