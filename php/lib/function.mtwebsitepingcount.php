<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitepingcount($args, &$ctx) {
    $count = $ctx->mt->db()->blog_ping_count($args);
    return $ctx->count_format($count, $args);
}
?>
