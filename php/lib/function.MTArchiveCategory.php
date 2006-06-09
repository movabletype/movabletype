<?php
function smarty_function_MTArchiveCategory($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        require_once("function.MTCategoryLabel.php");
        return smarty_function_MTCategoryLabel($args, $ctx);
    }

    $cat = $ctx->stash('archive_category');
    return $cat ? $cat['category_label'] : '';
}
?>
