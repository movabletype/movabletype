<?php
require_once('block.mtentriesheader.php');
function smarty_block_mtpagesheader($args, $content, &$ctx, &$repeat) {
    return smarty_block_mtentriesheader($args, $content, $ctx, $repeat);
}
?>
