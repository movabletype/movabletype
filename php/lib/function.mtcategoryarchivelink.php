<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcategoryarchivelink($args, &$ctx) {
    $category = $ctx->stash('category') or $ctx->stash('archive_category');
    if (!$category) {
        $entry = $ctx->stash('entry');
        if ($entry && ($entry['placement_category_id'])) {
            $category = $ctx->mt->db->fetch_category($entry['placement_category_id']);
        }
    }
    if (!isset($args['blog_id']))
        $args['blog_id'] = $ctx->stash('blog_id');
    if (!$category) return '';
    $link = $ctx->mt->db->category_link($category['category_id'], $args);
    if ($args['with_index'] && preg_match('/\/(#.*)$/', $link)) {
        $blog = $ctx->stash('blog');
        $index = $ctx->mt->config('IndexBasename');
        $ext = $blog['blog_file_extension'];
        if ($ext) $ext = '.' . $ext; 
        $index .= $ext;
        $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
    }
    return $link;
}
?>
