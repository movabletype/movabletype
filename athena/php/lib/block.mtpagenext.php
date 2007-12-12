<?php
require_once('block.mtentrynext.php');
function smarty_block_mtpagenext($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'page';
    return smarty_block_mtentrynext($args, $content, $ctx, $repeat);
}
?>
