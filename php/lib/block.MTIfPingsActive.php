<?php
function smarty_block_MTIfPingsActive($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_active = $blog['blog_allow_pings'] && $ctx->mt->config['AllowPings'];
        $entry = $ctx->stash('entry');
        if ($entry) {
            $active = $ctx->mt->db->entry_ping_count($entry['entry_id']) > 0;
            $active or $active = $blog_active && $entry['entry_allow_pings'];
        } else {
            $active = $blog_active;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $active);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
