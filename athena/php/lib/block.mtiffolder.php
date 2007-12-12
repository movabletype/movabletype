<?php
require_once('block.mtifcategory.php');
function smarty_block_mtiffolder($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtifcategory($args, $content, $ctx, $repeat);
}
?>
