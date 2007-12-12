<?php
function smarty_function_mtcategoryid($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    return $cat['category_id'];
}
?>
