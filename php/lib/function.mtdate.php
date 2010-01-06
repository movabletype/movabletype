<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtdate($args, &$ctx) {
    require_once("MTUtil.php");
    $t = time();
    $ts = offset_time_list($t, $ctx->stash('blog'));
    $args['ts'] = sprintf("%04d%02d%02d%02d%02d%02d",
        $ts[5]+1900, $ts[4]+1, $ts[3], $ts[2], $ts[1], $ts[0]);
    return $ctx->_hdlr_date($args, $ctx);
}
?>
