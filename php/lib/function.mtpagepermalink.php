<?php
require_once('function.mtentrypermalink.php');
function smarty_function_mtpagepermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $blog = $ctx->stash('blog');
    $at = 'Page';
    return $ctx->mt->db->entry_link($entry['entry_id'], $at, $args);
}
?>
