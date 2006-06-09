<?php
function smarty_function_MTRemoteSignOutLink($args, &$ctx) {
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    require_once "function.MTCGIPath.php";
    $path = smarty_function_MTCGIPath($args, $ctx);
    return $path . $ctx->mt->config['CommentScript'] .
        '?__mode=handle_sign_in&amp;' .
        ($args['static'] ? 'static=1' : 'static=0') .
        '&amp;logout=1' .
        '&amp;entry_id=' . $entry['entry_id'];
}
?>
