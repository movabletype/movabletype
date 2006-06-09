<?php
function smarty_block_MTCommenterIfTrusted($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $a = $ctx->stash('commenter');
        $approved = $a ? ($a['permission_role_mask'] & 1 ? 1 : 0) : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $approved);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
