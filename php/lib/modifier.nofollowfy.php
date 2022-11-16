<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_nofollowfy($str, $arg = 1) {
    # manipulate hyperlinks in $str...
    if (!isset($str)) return $str;
    if (!$arg) return $str;

    $mt = MT::get_instance();
    $ctx =& $mt->context();
    $blog = $ctx->stash('blog');

    $curr_tag = !empty($ctx->_tag_stack) ? $ctx->_tag_stack[count($ctx->_tag_stack) - 1] : null;
    $enable= false;
    if ( isset($curr_tag[1]['nofollowfy']) )
        $enable = $curr_tag[1]['nofollowfy'] ? true : false;

    if (!$enable && !$blog->blog_nofollow_urls)
        return $str;

    $arg = strtolower($arg);
    if ($arg == 'mtcommentbody' || $arg == 'mtcommentauthorlink' || $arg == 'mtcommenturl') {
        $comment = $ctx->stash('comment');
        if (!empty($comment->comment_commenter_id)) {
            // is an authenticated comment
            $auth = $comment->commenter();
            if ($auth && $blog->blog_follow_auth_links)
                return $str;
        }
    }
    return preg_replace_callback('#<a\s([^>]*\s*href\s*=[^>]*)>#i', 'nofollowfy_cb', $str);
}

function nofollowfy_cb($matches) {
    $str = $matches[1];
    preg_match_all('/[^=[:space:]]*\s*=\s*"[^"]*"|[^=[:space:]]*\s*=\s*\'[^\']*\'|[^=[:space:]]*\s*=[^[:space:]]*/', $str, $attr);
    $rel_arr = preg_grep('/^rel\s*=/i', $attr[0]);
    $attr = array_diff($attr[0], $rel_arr);
    if (count($rel_arr) > 0)
        $rel = array_pop($rel_arr);
    if (!empty($rel)) {
        $rel = preg_replace('/ ?\bnofollow\b ?/', ' ', $rel);
        $rel = preg_replace('/^(rel\s*=\s*[\'"]?) ?/i', '\1nofollow ', $rel);
    } else {
        $rel = 'rel="nofollow"';
    }
    return '<a ' . join(' ', $attr) . ' ' . $rel . '>';
}
?>
