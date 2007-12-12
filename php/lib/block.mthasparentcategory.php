<?php
function smarty_block_mthasparentcategory($args, $content, &$ctx, &$repeat) {
    $localvars = array('conditional','else_content');

    if (!isset($content)) {
        $ctx->localize($localvars);
        require_once("MTUtil.php");
        $cat = get_category_context($ctx);
        $has_parent = $cat['category_parent'];
        $ctx->stash('conditional', $has_parent);
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
