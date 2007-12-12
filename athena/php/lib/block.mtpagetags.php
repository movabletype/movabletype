<?php
require_once('block.mtentrytags.php');
function smarty_block_mtpagetags($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'page';
    return smarty_block_mtentrytags($args, $content, $ctx, $repeat);
}
?>
