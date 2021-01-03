<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtblogcategorycount($args, &$ctx) {
    require_once('multiblog.php');
    multiblog_function_wrapper('mtblogcategorycount', $args, $ctx);

    // status: complete
    // parameters: none
    $args['blog_id'] = $ctx->stash('blog_id');
    $count = $ctx->mt->db()->blog_category_count($args);
    return $ctx->count_format($count, $args);
}
?>
