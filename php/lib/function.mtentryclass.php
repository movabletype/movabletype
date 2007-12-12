<?php
function smarty_function_mtentryclass($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $class = $entry['entry_class'];
    if (!isset($class)) {
        return '';
    }
    if (isset($args['upper_case']) || isset($args['lower_case'])) {
        return $class; // to have global filters handle it.
    }
    // to be compatible with Perl version
    return strtoupper(substr($class, 0, 1)) . substr($class, 1);
} 
?>
