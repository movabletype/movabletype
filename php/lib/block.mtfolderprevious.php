<?php
require_once("block.mtcategorynext.php");
function smarty_block_mtfolderprevious($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtcategorynext($args, $content, $ctx, $repeat);
}
?>
