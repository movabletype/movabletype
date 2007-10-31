<?php
require_once('block.mtentryiftagged.php');
function smarty_block_mtpageiftagged($args, $content, &$ctx, &$repeat) {
    return smarty_block_mtentryiftagged($args, $content, $ctx, $repeat);
}
?>
