<?php
function smarty_function_MTCategoryArchiveLink($args, &$ctx) {
    $category = $ctx->stash('category') or $ctx->stash('archive_category');
    if (!$category) {
        $entry = $ctx->stash('entry');
        if ($entry && ($entry['placement_category_id'])) {
            $category = $ctx->mt->db->fetch_category($entry['placement_category_id']);
        }
    }
    if (!$category) return '';
    $link = $ctx->mt->db->category_link($category['category_id'], $args);
    if ($args['with_index'] && preg_match('/\/(#.*)$/', $link)) {
        $blog = $ctx->stash('blog');
        $index = $ctx->mt->config['IndexBasename'];
        $ext = $blog['blog_file_extension'];
        if ($ext) $ext = '.' . $ext; 
        $index .= $ext;
        $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
    }
    return $link;
}
?>
