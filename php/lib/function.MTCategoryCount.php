<?php
function smarty_function_MTCategoryCount($args, &$ctx) {
    $category = $ctx->stash('category');
    return $category['category_count'];
}
?>
