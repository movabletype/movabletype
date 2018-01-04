<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtremotesigninlink($args, &$ctx) {
    // status: complete
    // parameters: none
    global $_typekeytoken_cache;
    $blog = $ctx->stash('blog');
    $auths = $blog->blog_commenter_authenticators;
    if (!preg_match('/TypeKey/', $auths)) {
        return $ctx->error($ctx->mt->translate("TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used."));
    }
    $blog_id = $blog->blog_id;
    $token = 0;
    if (isset($_typekeytoken_cache[$blog_id])) {
        $token = $_typekeytoken_cache[$blog_id];
    } else {
        $token = $blog->blog_remote_auth_token;
        if ($token) {
            $_typekeytoken_cache[$blog_id] = $token;
        }
    }
    $entry = $ctx->stash('entry');
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $return = $path . $ctx->mt->config('CommentScript') .
              '%3f__mode=handle_sign_in%26' .
              'key=TypeKey%26'.
              ($args['static'] ? 'static=1' : 'static=0') .
              '%26entry_id=' . $entry->entry_id;
    $lang = $args['lang'];
    $lang or $lang = $ctx->mt->config('DefaultLanguage');
    $lang or $lang = $blog->blog_language;
    return $ctx->mt->config('SignOnURL') .
        '&amp;lang=' . $lang .
        ((isset($blog->blog_require_typekey_emails) && $blog->blog_require_typekey_emails) ? '&amp;need_email=1' : '') .
        '&amp;t=' . $token .
        '&amp;v=' . $ctx->mt->config('TypeKeyVersion') .
        '&amp;_return=' . $return;
}
?>
