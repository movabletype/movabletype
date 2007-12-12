<?php
function smarty_function_mtauthorauthiconurl($args, &$ctx) {
    $author = $ctx->stash('author');
    if (!$author) {
        return "";
    }
    require_once "function.mtstaticwebpath.php";
    $static_path = smarty_function_mtstaticwebpath($args, $ctx);
    require_once "commenter_auth_lib.php";
    return _auth_icon_url($static_path, $author);
}
?>
