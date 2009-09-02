<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mttaglabel.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('function.mttagname.php');
function smarty_function_mttaglabel($args, &$ctx) {
    return smarty_function_mttagname($args, $ctx);
}
?>
