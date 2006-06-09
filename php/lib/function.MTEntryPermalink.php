<?php
function smarty_function_MTEntryPermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $blog = $ctx->stash('blog');
    $at = $args['archive_type'];
    $at or $at = $blog['blog_archive_type_preferred'];
    if (!$at) {
        $at = $blog['blog_archive_type'];
        # strip off any extra archive types...
        $at = preg_replace('/,.*/', '', $at);
    }
    return $ctx->mt->db->entry_link($entry['entry_id'], $at, $args);
} 
?>
