<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

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
