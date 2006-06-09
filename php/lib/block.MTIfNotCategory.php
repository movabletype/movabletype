<?php
function smarty_block_MTIfNotCategory($args, $content, &$ctx, &$repeat) {
    require_once("block.MTIfCategory.php");
    return smarty_block_MTIfCategory($args, $context, $ctx, $repeat);
}
?>
