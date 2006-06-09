<?php
function smarty_function_MTCategoryLabel($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    return $cat['category_label'];
}
?>
