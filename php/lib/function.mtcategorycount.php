<?php
function smarty_function_mtcategorycount($args, &$ctx) {
    $category = $ctx->stash('category');
    return $category['category_count'];
}
?>
