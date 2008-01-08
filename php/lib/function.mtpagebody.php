<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('function.mtentrybody.php');
function smarty_function_mtpagebody($args, &$ctx) {
    return smarty_function_mtentrybody($args, $ctx);
}
?>
