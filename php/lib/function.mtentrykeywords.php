<?php
function smarty_function_mtentrykeywords($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['entry_keywords'];
}
?>
