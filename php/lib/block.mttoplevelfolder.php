<?php
require_once('block.mttoplevelparent.php');
function smarty_block_mttoplevelfolder($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mttoplevelparent($args, $content, $ctx, $repeat);
}
?>
