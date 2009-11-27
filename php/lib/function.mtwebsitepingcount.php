<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtwebsitepingcount($args, &$ctx) {
    require_once('function.mtblogpingcount.php');
    return smarty_function_mtblogpingcount($args, $ctx);
}
