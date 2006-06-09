<?php
function smarty_block_MTIfTypeKeyToken($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $blog['blog_remote_auth_token'] ? 1 : 0);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
