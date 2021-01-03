<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcomments($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('comments', 'comment_order_num','comment','current_timestamp', 'commenter', 'blog', 'blog_id', 'conditional', 'else_content', '_comments_glue', '_comments_out'), common_loop_vars());
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        if ($entry)
            $args['entry_id'] = $entry->entry_id;
        $blog = $ctx->stash('blog');
        if ($blog)
            $args['blog_id'] = $blog->blog_id;
        $comments = $ctx->mt->db()->fetch_comments($args);
        $ctx->stash('comments', $comments);
        $counter = 0;
        $out = false;
        $ctx->stash('_comments_glue', $args['glue']);
        $ctx->stash('_comments_out', false);
    } else {
        $comments = $ctx->stash('comments');
        $counter = $ctx->stash('comment_order_num');
        $out = $ctx->stash('_comments_out');
    }

    if (empty($comments)) {
        $ret = $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
        if (!$repeat)
              $ctx->restore($localvars);
        return $ret;
    }

    $ctx->stash('conditional', empty($comments) ? 0 : 1);
    if ($counter < count($comments)) {
        $blog_id = $ctx->stash('blog_id');
        $comment = $comments[$counter];
        if ($comment->comment_commenter_id) {
            $commenter = $comment->commenter();
            if (empty($commenter)) {
                $ctx->__stash['commenter'] = null;
            } else {
                $ctx->stash('commenter', $commenter);
            }
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

        $glue = $ctx->stash('_comments_glue');
        if (isset($glue) && !empty($content)) {
            if ($out)
                $content = $glue . $content;
            else
                $ctx->stash('_comments_out', true);
        }
    } else {
        $glue = $ctx->stash('_comments_glue');
        if (isset($glue) && $out && !empty($content))
            $content = $glue . $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
