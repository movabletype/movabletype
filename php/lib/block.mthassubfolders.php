<?php
require_once('block.mthassubcategories.php');
function smarty_block_mthassubfolders($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mthassubcategories($args, $content, $ctx, $repeat);
}
?>
