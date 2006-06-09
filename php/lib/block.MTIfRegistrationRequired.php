<?php
function smarty_block_MTIfRegistrationRequired($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $blog['blog_allow_reg_comments'] && $blog['blog_remote_auth_token'] && !$blog['blog_allow_unreg_comments']);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
