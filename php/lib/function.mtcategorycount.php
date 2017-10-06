<?php
# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategorycount($args, &$ctx) {
    require_once("MTUtil.php");
    $category = get_category_context($ctx);
    if (!$category) return '';
    if (!$category->category_category_set_id) {
        $count = $category->entry_count();
    } else {
        $terms = array();
        if (isset($args['content_field_id']) && $args['content_field_id']) {
            $terms['content_field_id'] = $args['content_field_id'];
        } else if (isset($args['content_type_id']) && $args['content_type_id']) {
            $terms['content_type_id'] = $args['content_type_id'];
        } else if ($ctx->stash('content_field')) {
            $terms['content_field_id'] = $ctx->stash('content_field')->id;
        } else if ($ctx->stash('content_type')) {
            $terms['content_type_id'] = $ctx->stash('content_type')->id;
        }
        $count = $category->content_data_count($terms);
    }
    return $ctx->count_format($count, $args);
}
?>
