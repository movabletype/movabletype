<?php
function smarty_function_mtcategorydescription($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    return $cat['category_description'];
}
?>
