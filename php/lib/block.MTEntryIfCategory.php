<?php
require_once("block.MTIfCategory.php");
function smarty_block_MTEntryIfCategory($args, $content, &$ctx, &$repeat) {
    return smarty_block_MTIfCategory($args, $content, $ctx, $repeat);
}
?>
