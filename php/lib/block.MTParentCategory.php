<?php
function smarty_block_MTParentCategory($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ctx->localize(array('category', 'conditional', 'else_content'));
        require_once("MTUtil.php");
        $cat = get_category_context($ctx);
        if (($cat) && ($cat['category_parent'])) {
            $parent_cat = $ctx->mt->db->fetch_category($cat['category_parent']);
            $ctx->stash('category', $parent_cat);
        }
        $ctx->stash('conditional', isset($parent_cat));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('category', 'conditional', 'else_content'));
    }
    return $content;
}
?>
