<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

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
        $count = $counter + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($comments));
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
