<?php
function smarty_function_MTEntryCommentCount($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $entry_id = $entry['entry_id'];
    return $ctx->mt->db->entry_comment_count($entry_id);
}
?>
