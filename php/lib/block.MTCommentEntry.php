<?php
function smarty_block_MTCommentEntry($args, $content, &$ctx, &$repeat) {
    $localvars = array('entry', 'current_timestamp', 'modification_timestamp');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $comment = $ctx->stash('comment');
        $entry_id = $comment['comment_entry_id'];
        $entry = $ctx->mt->db->fetch_entry($entry_id);
        $ctx->stash('entry', $entry);
        $ctx->stash('current_timestamp', $entry['entry_created_on']);
        $ctx->stash('modification_timestamp', $entry['entry_modified_on']);
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}
?>
