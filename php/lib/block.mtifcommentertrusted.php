<?php
function smarty_block_mtifcommentertrusted($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $cmtr = $ctx->stash('commenter');
        $trusted = ($cmtr && ($cmtr['permission_role_mask'] & 1)) ? 1 : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $trusted);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
