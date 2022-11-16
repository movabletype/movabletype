<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
        if (isset($args['content_field']) && $args['content_field']) {
            if (is_numeric($args['content_field'])) {
                $terms['content_field_id'] = $args['content_field'];
            } else {
                $cf_arg = $args['content_field'];
                require_once("class.mt_content_field.php");
                $content_field = new ContentField();
                $content_field->Load("cf_unique_id = '$cf_arg'");
                if ($content_field->id) {
                    $terms['content_field_id'] = $content_field->id;
                } else {
                    $terms['content_field_name'] = $args['content_field'];
                }
            }
        } else if ($ctx->stash('content_field')) {
            $terms['content_field_id'] = $ctx->stash('content_field')->id;
        }
        if (isset($args['content_type']) && $args['content_type']) {
            if (is_numeric($args['content_type'])) {
                $terms['content_type_id'] = $args['content_type'];
            } else {
                $content_type = get_content_type_context($ctx, $args);
                if (isset($content_type)) {
                    $terms['content_type_id'] = $content_type->id;
                }
            }
        } else if ($ctx->stash('content_type')) {
            $terms['content_type_id'] = $ctx->stash('content_type')->id;
        }
        $count = $category->content_data_count($terms);
    }
    return $ctx->count_format($count, $args);
}
?>
