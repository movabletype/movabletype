<?php
function smarty_function_mtentryclass($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $class = $entry['entry_class'];
    if (!isset($class)) {
        return '';
    }
    return $class;
} 
?>
