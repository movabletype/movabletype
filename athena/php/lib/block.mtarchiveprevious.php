<?php
require_once("archive_lib.php");
function smarty_block_mtarchiveprevious($args, $content, &$ctx, &$repeat) {
    return _hdlr_archive_prev_next($args, $content, $ctx, $repeat, 'archiveprevious');
}
?>
