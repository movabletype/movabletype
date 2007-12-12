<?php
function smarty_block_mthasnoparentcategory($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        require_once("MTUtil.php");
        $cat = get_category_context($ctx);
        $has_no_parent = !$cat['category_parent'] ? 1 : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_no_parent);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
