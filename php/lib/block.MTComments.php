<?php
function smarty_block_MTComments($args, $content, &$ctx, &$repeat) {
    $localvars = array('comments', 'comment_order_num','comment','current_timestamp', 'commenter');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        if ($entry)
            $args['entry_id'] = $entry['entry_id'];
        $blog = $ctx->stash('blog');
        if ($blog)
            $args['blog_id'] = $blog['blog_id'];
        $comments = $ctx->mt->db->fetch_comments($args);
        $ctx->stash('comments', $comments);
        $counter = 0;
    } else {
        $comments = $ctx->stash('comments');
        $counter = $ctx->stash('comment_order_num');
    }
    if ($counter < count($comments)) {
        $comment = $comments[$counter];
        if ($comment['comment_commenter_id']) {
            $commenter = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);
            $ctx->stash('commenter', $commenter);
        } else {
            $ctx->__stash['commenter'] = null;
        }
        $ctx->stash('comment', $comment);
        $ctx->stash('current_timestamp', $comment['comment_created_on']);
        $ctx->stash('comment_order_num', $counter + 1);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
