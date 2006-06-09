<?php
function smarty_function_MTEntryTrackbackCount($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $entry_id = $entry['entry_id'];
    return $ctx->mt->db->entry_ping_count($entry_id);
}
?>