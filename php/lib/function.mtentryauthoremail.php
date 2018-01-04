<?php
function smarty_function_mtentryauthoremail($args, &$ctx) {
    // status: incomplete
    // parameters: spam_protect
    $entry = $ctx->stash('entry');
    if (isset($args['spam_protect']) && $args['spam_protect']) {
        return spam_protect($entry->author()->email);
    } else {
        return $entry->author()->email;
    }
}
?>
