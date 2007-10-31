<?php
function smarty_function_mtblogcategorycount($args, &$ctx) {
    // status: complete
    // parameters: none
    $args['blog_id'] = $ctx->stash('blog_id');
    $count = $ctx->mt->db->blog_category_count($args);
    return $count;
}
?>
