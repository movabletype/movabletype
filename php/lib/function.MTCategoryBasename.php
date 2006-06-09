<?php
function smarty_function_MTCategoryBasename($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    return $cat['category_basename'];
}
?>
