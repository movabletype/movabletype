<?php
function smarty_function_mtentryatomid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['entry_atom_id'];
}
?>
