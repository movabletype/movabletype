<?php
function smarty_function_mtentryid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return (isset($args['pad']) && $args['pad']) ? sprintf("%06d", $entry['entry_id']) : $entry['entry_id'];
}
?>
