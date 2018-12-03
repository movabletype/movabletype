<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategoryarchivelink($args, &$ctx) {
    require_once('MTUtil.php');
    $category = get_category_context($ctx);
    if (!$category) return '';
    $category_set = $ctx->stash('category_set');
    $at = isset($category_set) && $category_set ? 'ContentType-Category' : 'Category';
    $link = $ctx->mt->db()->category_link($category->category_id, $at);
    if ($args['with_index'] && preg_match('/\/(#.*)*$/', $link)) {
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
