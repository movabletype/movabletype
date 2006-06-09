<?php
function smarty_block_MTIfCommentsAllowed($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat,
                              ($blog['blog_allow_unreg_comments']
                               || ($blog['blog_allow_reg_comments']
                                   && $blog['blog_remote_auth_token']))
                              && $ctx->mt->config['AllowComments']);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
