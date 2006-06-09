<?php
function smarty_block_MTIfCommentsActive($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_active = ($blog['blog_allow_unreg_comments']
	                || ($blog['blog_allow_reg_comments']
			    && $blog['blog_remote_auth_token']))
	               && $ctx->mt->config['AllowComments'];
        $entry = $ctx->stash('entry');
        if ($entry) {
            $active = $ctx->mt->db->entry_comment_count($entry['entry_id']) > 0;
            $active or $active = $entry['entry_allow_comments'];
        } else {
            $active = $blog_active;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $active);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
