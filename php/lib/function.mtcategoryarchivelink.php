<?php
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
    $at = $args['type'];
    $at or $at = $args['archive_type'];
    $at or $at = $ctx->stash('current_archive_type');
    if ($at == 'Category') {
        $link = $ctx->mt->db->category_link($category['category_id'], $args);
    } else {
        return '';
    }
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
