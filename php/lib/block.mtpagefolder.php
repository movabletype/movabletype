<?php
require_once('block.mtentrycategories.php');
function smarty_block_mtpagefolder($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtentrycategories($args, $content, $ctx, $repeat);
}
?>
