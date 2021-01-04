<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcommentbody($args, &$ctx) {
    $comment = $ctx->stash('comment');
    $text = $comment->comment_text;

    $blog = $ctx->stash('blog');
    if (!$blog->blog_allow_comment_html) {
        $text = strip_tags($text);
    }
    $cb = isset($args['convert_breaks']) ? $args['convert_breaks'] : $blog->blog_convert_paras_comments;
    if ($cb == '1' || $cb == '__default__') {
        $cb = 'convert_breaks';
    }

    require_once 'MTUtil.php';
    if ( $cb != '0' ) {
        $text = apply_text_filter($ctx, $text, $cb);
    }

    if (isset($args['words'])) {
        require_once("MTUtil.php");
        return first_n_text($text, $args['words']);
    }

    if ($blog->blog_autolink_urls) {
        $text = preg_replace('!(^|\s|>)(https?://[^\s<]+)!s', '$1<a href="$2">$2</a>', $text);
    }
    return $text;
}
?>
