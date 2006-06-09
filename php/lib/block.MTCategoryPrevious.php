<?php
require_once("block.MTCategoryNext.php");
function smarty_block_MTCategoryPrevious($args, $content, &$ctx, &$repeat) {
    return smarty_block_MTCategoryNext($args, $content, $ctx, $repeat);
}
?>
