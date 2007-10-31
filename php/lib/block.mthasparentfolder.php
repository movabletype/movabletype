<?php
require_once('block.mthasparentcategory.php');
function smarty_block_mthasparentfolder($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mthasparentcategory($args, $content, $ctx, $repaet);
}
?>
