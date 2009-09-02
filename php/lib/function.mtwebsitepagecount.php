<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtwebsitepagecount.php 107171 2009-07-19 16:09:46Z ytakayama $

require_once('function.mtblogentrycount.php');
function smarty_function_mtwebsitepagecount($args, &$ctx) {
    // status: complete
    // parameters: none
    $args['class'] = 'page';
    return smarty_function_mtblogentrycount($args, $ctx);
}
