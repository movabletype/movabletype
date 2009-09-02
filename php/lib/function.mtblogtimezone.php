<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtblogtimezone.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtblogtimezone($args, &$ctx) {
    // status: complete
    // parameters: no_colon
    $blog = $ctx->stash('blog');
    $so = $blog->blog_server_offset;
    $no_colon = isset($args['no_colon']) ? $args['no_colon'] : 0;
    $partial_hour_offset = 60 * abs($so - intval($so));
    return sprintf("%s%02d%s%02d", ($so < 0 ? '-' : '+'),
                   abs($so), ($no_colon ? '' : ':'),
                   $partial_hour_offset);
}
?>
