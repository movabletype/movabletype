<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentrycreateddate.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtentrycreateddate($args, &$ctx) {
    $e = $ctx->stash('entry');
    $args['ts'] = $e->entry_created_on;
    return $ctx->_hdlr_date($args, $ctx);
}
?>
