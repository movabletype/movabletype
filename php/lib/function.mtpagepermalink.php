<?php
require_once('function.mtentrypermalink.php');
function smarty_function_mtpagepermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $blog = $ctx->stash('blog');
    $at = 'Page';
    if (!isset($args['blog_id']))
        $args['blog_id'] = $blog['blog_id'];
    return $ctx->mt->db->entry_link($entry['entry_id'], $at, $args);
}
?>
