<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('function.mtblogentrycount.php');
function smarty_function_mtblogpagecount($args, &$ctx) {
    // status: complete
    // parameters: none
    $args['class'] = 'page';
    return smarty_function_mtblogentrycount($args, $ctx);
}
