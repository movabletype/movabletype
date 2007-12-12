<?php
function smarty_function_mtsubcategorypath($args, &$ctx) {
    require_once("block.mtparentcategories.php");
    require_once("function.mtcategorylabel.php");
    require_once("modifier.dirify.php");

    $args = array('glue' => '/');
    $content = null;
    $repeat = true;
    smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    $res = '';
    while ($repeat) {
        $content = smarty_function_mtcategorylabel(array(), $ctx);
        $content = smarty_modifier_dirify($content, isset($args['separator']) ? $args['separator'] : '1');
        $res .= smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    }
    return $res;
}
?>
