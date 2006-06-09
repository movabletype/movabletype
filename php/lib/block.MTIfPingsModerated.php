<?php
function smarty_block_MTIfPingsModerated($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $moderated = ($blog['blog_moderate_pings'];
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $moderated);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
