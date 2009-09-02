<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtwebsiteurl.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_function_mtwebsiteurl($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogurl.php');
    return smarty_function_mtblogurl($args, $ctx);
}
?>
