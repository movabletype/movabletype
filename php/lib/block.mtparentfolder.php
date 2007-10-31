<?php
require_once('block.mtparentcategory.php');
function smarty_block_mtparentfolder($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtparentcategory($args, $content, $ctx, $repeat);
}
?>
