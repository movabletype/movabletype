<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtcommentreplies($args, $content, &$ctx, &$repeat) {
    $localvars = array('comments', 'comment_order_num', 'comment','current_timestamp', 'commenter', 'blog', 'blog_id', '_comment_replies_tokens', 'conditional', 'else_content');
    $token_fn = $ctx->stash('_comment_replies_tokens');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $token_fn = $args['token_fn'];
        $comment = $ctx->stash('comment');
        if (!$comment) { $repeat = false; return ''; }
        $args['comment_id'] = $comment['comment_id'];
        $comments = $ctx->mt->db->fetch_comment_replies($args);
        if (!$comments) { $repeat = false; return ''; }
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
