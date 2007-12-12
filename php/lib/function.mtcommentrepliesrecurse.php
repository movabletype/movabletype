<?php
function smarty_function_mtcommentrepliesrecurse($args, &$ctx) {
    $localvars = array('comments', 'comment_order_num', 'comment','current_timestamp', 'commenter', 'blog', 'blog_id');
    $token_fn = $ctx->stash('_comment_replies_tokens');

    $comment = $ctx->stash('comment');
    if (!$comment) { $repeat = false; return ''; }
    $args['comment_id'] = $comment['comment_id'];
    $comments = $ctx->mt->db->fetch_comment_replies($args);
    if (!$comments) { $repeat = false; return ''; }
    $ctx->stash('comments', $comments);

    $counter = 0;
    $content = '';

    $ctx->localize($localvars);
    while ($comment = array_shift($comments)) {
        $blog_id = $ctx->stash('blog_id');
        if ($comment['comment_commenter_id']) {
            $commenter = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);
            $ctx->stash('commenter', $commenter);
        } else {
            $ctx->__stash['commenter'] = null;
        }
        if ($blog_id != $comment['comment_blog_id']) {
            $blog_id = $comment['comment_blog_id'];
            $ctx->stash('blog_id', $blog_id);
            $ctx->stash('blog', $ctx->mt->db->fetch_blog($blog_id));
        }
        $ctx->stash('comment', $comment);
        $ctx->stash('current_timestamp', $comment['comment_created_on']);
        $ctx->stash('comment_order_num', $counter + 1);
        ob_start();
        $token_fn($ctx, array());
        $content .= ob_get_contents();
        ob_end_clean();
        $counter++;
    }
    $ctx->restore($localvars);
    return $content;
}
?>
