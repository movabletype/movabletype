<?php
function smarty_function_MTEntryFlag($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $flag = 'entry_' . $args['flag'];
    if (isset($entry[$flag])) {
        $v = $entry[$flag];
    }
    if ($flag == 'allow_pings') {
       return isset($v) ? $v : 0; 
    } else {
       return isset($v) ? $v : 1;
    }
}
?>
