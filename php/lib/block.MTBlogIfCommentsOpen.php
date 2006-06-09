<?php
function smarty_block_MTBlogIfCommentsOpen($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if ($ctx->mt->config['AllowComments'] &&
            (($blog['blog_allow_reg_comments'] && $blog['blog_remote_auth_token'])
             || $blog['blog_allow_unreg_comments']))
            $open = 1;
        else
            $open = 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $open);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
