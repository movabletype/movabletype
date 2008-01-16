<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('rating_lib.php');

function smarty_function_mtassetscorelow($args, &$ctx) {
    return hdlr_score_low($ctx, 'asset', $args['namespace']);
}
?>

