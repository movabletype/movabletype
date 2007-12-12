<?php
function smarty_function_mtarchivecategory($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        require_once("function.mtcategorylabel.php");
        return smarty_function_mtcategorylabel($args, $ctx);
    }

    $cat = $ctx->stash('archive_category');
    return $cat ? $cat['category_label'] : '';
}
?>
