<?php
require_once('block.mttoplevelcategories.php');
function smarty_block_mttoplevelfolders($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mttoplevelcategories($args, $content, $ctx, $repeat);
}
?>
