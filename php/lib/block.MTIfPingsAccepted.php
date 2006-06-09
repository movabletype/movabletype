<?php
function smarty_block_MTIfPingsAccepted($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $entry = $ctx->stash('entry');
        $blog_accepted = $blog['blog_allow_pings'] && $ctx->mt->config['AllowPings'];
        if ($entry) {
            $accepted = $blog_accepted && $entry['entry_allow_pings'];
        } else {
            $accepted = $blog_accepted;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $accepted);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
