<?php
require_once("block.mtcategorynext.php");
function smarty_block_mtcategoryprevious($args, $content, &$ctx, &$repeat) {
    return smarty_block_mtcategorynext($args, $content, $ctx, $repeat);
}
?>
