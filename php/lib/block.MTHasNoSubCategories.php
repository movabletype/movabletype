<?php
require_once("block.MTHasSubCategories.php");
function smarty_block_MTHasNoSubCategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('conditional','else_content');

    if (!isset($content)) {
        $ctx->localize($localvars);
        $has_no_sub_cats = !_has_sub_categories($ctx);
        $ctx->stash('conditional', $has_no_sub_cats);
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore($localvars);
    }
    return $content;
}
?>
