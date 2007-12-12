<?php
require_once('block.mtparentcategories.php');
function smarty_block_mtparentfolders($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
}
?>
