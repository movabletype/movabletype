<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcommentreplies($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('comments', 'comment_order_num', 'comment','current_timestamp', 'commenter', 'blog', 'blog_id', '_comment_replies_tokens', 'conditional', 'else_content'), common_loop_vars());
    $token_fn = $ctx->stash('_comment_replies_tokens');
    if (!isset($content)) {
        $token_fn = $args['token_fn'];
        $comment = $ctx->stash('comment');
        if (!$comment) { $repeat = false; return ''; }
        $args['comment_id'] = $comment->comment_id;
        $comments = $ctx->mt->db()->fetch_comment_replies($args);
        if (!$comments) { $repeat = false; return ''; }
        $ctx->localize($localvars);
        $ctx->stash('comments', $comments);
        $ctx->stash('_comment_replies_tokens', $token_fn);
        $counter = 0;
    } else {
        $comments = $ctx->stash('comments');
        $counter = $ctx->stash('comment_order_num');
    }

    $ctx->stash('conditional', empty($comments) ? 0 : 1);
    if (empty($comments)) {
        $ret = $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
        if (!$repeat)
              $ctx->restore($localvars);
        return $ret;
    }

    if ($counter < count($comments)) {
        $blog_id = $ctx->stash('blog_id');
        $comment = $comments[$counter];
        if ($comment->comment_commenter_id) {
            $commenter = $comment->commenter();
            $ctx->stash('commenter', $commenter);
        } else {
            $ctx->__stash['commenter'] = null;
        }
        if ($blog_id != $comment->comment_blog_id) {
            $blog_id = $comment->comment_blog_id;
            $ctx->stash('blog_id', $blog_id);
            $ctx->stash('blog', $comment->blog());
        }
        $ctx->stash('comment', $comment);
        $ctx->stash('current_timestamp', $comment->comment_created_on);
        $ctx->stash('comment_order_num', $counter + 1);
        $repeat = true;
        $count = $counter + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($comments));
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
