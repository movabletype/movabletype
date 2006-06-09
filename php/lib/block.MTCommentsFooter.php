<?php
function smarty_block_MTCommentsFooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $comments = $ctx->stash('comments');
        $counter = $ctx->stash('comment_order_num');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $counter == count($comments));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
