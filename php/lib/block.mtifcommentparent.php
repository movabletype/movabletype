<?php
function smarty_block_mtifcommentparent($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat,  $comment['comment_parent_id'] ? 1 : 0);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
