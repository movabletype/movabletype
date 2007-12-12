<?php
function smarty_block_mtifcommentsmoderated($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $moderated = ($blog['blog_moderate_unreg_comments'] || $blog['blog_manual_approve_commenters']);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $moderated);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
