<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('function.mtentryid.php');
function smarty_function_mtpageid($args, &$ctx) {
    return smarty_function_mtentryid($args, $ctx);
}
?>
