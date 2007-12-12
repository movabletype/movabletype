<?php
function smarty_function_mtentryclasslabel($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $class = $entry['entry_class'];
    if (!isset($class)) {
        return '';
    }
    return $ctx->mt->translate($class);
    // translate('page'), translate('entry')
    // translate('Page'), translate('Entry')
} 
?>
