<?php
function smarty_block_mtifcommentreplies($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        $args['comment_id'] = $comment['comment_id'];
        $children = $ctx->mt->db->fetch_comment_replies($args);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, count($children));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
