<?php
function smarty_function_MTSubCategoryPath($args, &$ctx) {
    require_once("block.MTParentCategories.php");
    require_once("function.MTCategoryLabel.php");
    require_once("modifier.dirify.php");

    $args = array('glue' => '/');
    $content = null;
    $repeat = true;
    smarty_block_MTParentCategories($args, $content, $ctx, $repeat);
    $res = '';
    while ($repeat) {
        $content = smarty_function_MTCategoryLabel(array(), $ctx);
        $content = smarty_modifier_dirify($content, isset($args['separator']) ? $args['separator'] : '1');
        $res .= smarty_block_MTParentCategories($args, $content, $ctx, $repeat);
    }
    return $res;
}
?>
