<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_nofollowfy($str, $arg = 1) {
    # manipulate hyperlinks in $str...
    if (!isset($str)) return $str;
    if (!$arg) return $str;

    global $mt;
    $ctx =& $mt->context();
    $blog = $ctx->stash('blog');

    if (!$blog['blog_nofollow_urls'])
        return $str;

    $arg = strtolower($arg);
    if ($arg == 'mtcommentbody' || $arg == 'mtcommentauthorlink' || $arg == 'mtcommenturl') {
        $comment = $ctx->stash('comment');
        if ($comment['comment_commenter_id']) {
            // is an authenticated comment
            $auth = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);
            if ($auth && $blog['blog_follow_auth_links'])
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
    if ($rel) {
        $rel = preg_replace('/ ?\bnofollow\b ?/', ' ', $rel);
        $rel = preg_replace('/^(rel\s*=\s*[\'"]?) ?/i', '\1nofollow ', $rel);
    } else {
        $rel = 'rel="nofollow"';
    }
    return '<a ' . join(' ', $attr) . ' ' . $rel . '>';
}
?>
