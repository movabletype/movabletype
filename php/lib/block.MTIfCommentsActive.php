<?php
function smarty_block_MTIfCommentsActive($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_accepts_comments = ($blog['blog_allow_reg_comments'] &&
            $blog['blog_remote_auth_token']) ||
            $blog['blog_allow_unreg_comments'];
        $entry = $ctx->stash('entry');
        if ($entry) {
            if ($blog_accepts_comments && $entry['entry_allow_comments'] && $ctx->mt->config['AllowComments'])
                $active = 1;
            if ($ctx->mt->db->entry_comment_count($entry['entry_id']))
                $active = 1;
        } else {
            $active = $blog_accepts_comments && $ctx->mt->config['AllowComments'];
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $active);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>