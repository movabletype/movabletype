<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('function.mtblogentrycount.php');
function smarty_function_mtwebsitepagecount($args, &$ctx) {
    // status: complete
    // parameters: none
    $args['class'] = 'page';
    $count = $ctx->mt->db()->blog_entry_count($args);
    return $ctx->count_format($count, $args);
}
?>
