<?php
function smarty_function_mtcategorycommentcount($args, &$ctx) {
    global $mt;
    $db =& $mt->db;
    $category = $ctx->stash('category');
    $cat_id = (int)$category['category_id'];
    if (!$cat_id) return 0;
    return $db->category_comment_count(array( 'category_id' => $cat_id ));
}
?>
