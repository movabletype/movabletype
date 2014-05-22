<?php
# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategoryarchivelink($args, &$ctx) {
    $category = $ctx->stash('category') or $ctx->stash('archive_category');
    if (!$category) {
        $entry = $ctx->stash('entry');
        if (!empty($entry) && ($categoty = $entry->category())) {
            $category = $entry->category();
        }
    }
    if (!isset($args['blog_id']))
        $args['blog_id'] = $ctx->stash('blog_id');
    if (!$category) return '';
    $link = $ctx->mt->db()->category_link($category->category_id, $args);
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
