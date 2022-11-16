<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategoryarchivelink($args, &$ctx) {
    require_once('MTUtil.php');
    $category = get_category_context($ctx);
    if (!$category) return '';

    if ($ctx->stash('content') || $category->category_category_set_id) {
        $cat_at_label = 'ContentType-Category';
    } else {
        $cat_at_label = 'Category';
    }

    $curr_at = $ctx->stash('current_archive_type');
    $curr_at or $curr_at = $ctx->stash('archive_type');
    $curr_at or $curr_at = $cat_at_label;

    $blog = $ctx->stash('blog');
    if (!$blog && $curr_at !== $cat_at_label) {
        return '';
    }
    if ($curr_at !== $cat_at_label) {
        $blog_at = $blog->archive_type;
        $blog_ats = explode(',', $blog_at);
        $cat_arc = false;
        foreach ($blog_ats as $at) {
            if ($cat_at_label === $at) {
                $cat_arc = true;
                break;
            }
        }
        if (!$cat_arc) {
            return $ctx->error($ctx->mt->translate(
                '[_1] cannot be used without publishing [_2] archive.',
                '<$MTCategoryArchiveLink$>',
                $cat_at_label
            ));
        }
    }

    $content_type_id = $ctx->stash('content_type') ? $ctx->stash('content_type')->id : 0;
    $link = $ctx->mt->db()->category_link($category->category_id, $cat_at_label, $content_type_id);
    if (!empty($args['with_index']) && preg_match('/\/(#.*)*$/', $link)) {
        $blog = $ctx->stash('blog');
        $index = $ctx->mt->config('IndexBasename');
        $ext = $blog->blog_file_extension;
        if ($ext) $ext = '.' . $ext; 
        $index .= $ext;
        $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
    }
    return $link;
}
?>
