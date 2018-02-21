<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategorycount($args, &$ctx) {
    require_once("MTUtil.php");
    $category = get_category_context($ctx);
    if (!$category) return '';
    $count = $category->entry_count();
    return $ctx->count_format($count, $args);
}
?>
