<?php
function smarty_function_MTEntryTrackbackID($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['trackback_id'];
}
?>
