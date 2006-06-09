<?php
function smarty_function_MTRemoteSignInLink($args, &$ctx) {
    // status: complete
    // parameters: none
    global $_typekeytoken_cache;
    $blog = $ctx->stash('blog');
    $blog_id = $blog['blog_id'];
    $token = 0;
    if (isset($_typekeytoken_cache[$blog_id])) {
        $token = $_typekeytoken_cache[$blog_id];
    } else {
        $token = $blog['blog_remote_auth_token'];
        if ($token) {
            $_typekeytoken_cache[$blog_id] = $token;
        }
    }
    $entry = $ctx->stash('entry');
    require_once "function.MTCGIPath.php";
    $path = smarty_function_MTCGIPath($args, $ctx);
    $return = $path . $ctx->mt->config['CommentScript'] .
              '%3f__mode=handle_sign_in%26' .
              ($args['static'] ? 'static=1' : 'static=0') .
              '%26entry_id=' . $entry['entry_id'];
    return $ctx->mt->config['SignOnURL'] .
        '&amp;lang=' . $blog['blog_language'] .
        ((isset($blog['blog_require_comment_emails']) && $blog['blog_require_comment_emails']) ? '&amp;need_email=1' : '') .
        '&amp;t=' . $token .
        '&amp;v=' . $ctx->mt->config['TypeKeyVersion'] .
        '&amp;_return=' . $return;
}
?>
