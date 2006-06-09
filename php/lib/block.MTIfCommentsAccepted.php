<?php
function smarty_block_MTIfCommentsAccepted($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_accepted = (($blog['blog_allow_unreg_comments'] || 
		       	   ($blog['blog_allow_reg_comments']
			    && $blog['blog_remote_auth_token']))
			   && $ctx->mt->config['AllowComments']);
        $entry = $ctx->stash('entry');
        if ($entry) {
            $accepted = $blog_accepted && $entry['entry_allow_comments'];
        } else {
            $accepted = $blog_accepted;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $accepted);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
