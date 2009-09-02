<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentryrank.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('rating_lib.php');

function smarty_function_mtentryrank($args, &$ctx) {
    return hdlr_rank($ctx, 'entry', $args['namespace'], $args['max'],
        "AND (entry_status = 2)\n", $args
    );
}
?>
