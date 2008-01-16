<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('function.mtentrytitle.php');
function smarty_function_mtpagetitle($args, &$ctx) {
    return smarty_function_mtentrytitle($args, $ctx);
}
?>
