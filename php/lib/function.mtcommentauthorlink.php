<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentauthorlink($args, &$ctx) {
    global $mt;
    $comment = $ctx->stash('comment');
    $name = $comment['comment_author'];
    if (!$name && isset($args['default_name']))
        $name = $args['default_name'];
    $name or $name = $mt->translate("Anonymous");
    $email = $comment['comment_email'];
    $url = $comment['comment_url'];
    if (isset($args['show_email']))
        $show_email = $args['show_email'];
    else
        $show_email = 0;
    if (isset($args['show_url']))
        $show_url = $args['show_url'];
    else
        $show_url = 1;
    $target = (isset($args['new_window']) && $args['new_window'])
        ? ' target="_blank"' : '';

    _comment_follow($args, $ctx);

    $cmntr = $ctx->stash('commenter');
    if (!isset($cmntr) && isset($comment['comment_commenter_id']))
        $cmntr = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);

    if ( $cmntr ) {
        $name = isset($cmntr['author_nickname']) ? $cmntr['author_nickname'] : $name;
        if ($cmntr['author_url'])
            return sprintf('<a title="%s" href="%s"%s>%s</a>', $cmntr['author_url'], $cmntr['author_url'], $target, $name);
        return $name;
    } elseif ($show_url && $url) {
        require_once "function.mtcgipath.php";
        $cgi_path = smarty_function_mtcgipath($args, $ctx);
        $comment_script = $ctx->mt->config('CommentScript');
        $name = strip_tags($name);
        $url = strip_tags($url);
        $url = preg_replace('/>/', '&gt;', $url);
        if ($comment['comment_id'] && !isset($args['no_redirect']) && !isset($args['nofollowfy']))
            return sprintf('<a title="%s" href="%s%s?__mode=red;id=%d"%s>%s</a>', $url, $cgi_path, $comment_script, $comment['comment_id'], $target, $name);
        else
            return sprintf('<a title="%s" href="%s"%s>%s</a>', $url, $url, $target, $name);
    } elseif ($show_email && $email && is_valid_email($email)) {
        $email = strip_tags($email);
        $str = 'mailto:' . $email;
        if ($args['spam_protect']) {
            $str = spam_protect($str);
        }
        return sprintf('<a href="%s">%s</a>', $str, $name);
    }
    return $name;

}

function _comment_follow (&$args, $ctx) {
    $comment = $ctx->stash('comment');
    if (empty($comment))
        return;

    $blog = $ctx->stash('blog');
    if (!empty($blog) && $blog['blog_nofollow_urls']) {
        if ($blog['blog_follow_auth_links']) {
            $cmntr = $ctx->stash('commenter');
            if (!isset($cmntr) && isset($comment['comment_commenter_id'])) {
                $cmntr = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);
                if (!empty($cmntr))
                    $ctx->stash('commenter', $cmntr);
            }
            if (empty($cmntr) || (!empty($cmntr) && !is_trusted($cmntr, $ctx, $blog['blog_id'])))
                $args['nofollowfy'] = 1;
        } else {
            $args['nofollowfy'] = 1;
        }
    }
}

function is_trusted ($cmntr, $ctx, $blog_id) {
    if (empty($cmntr))
        return false;

    // commenter is superuser?
    $perms = $ctx->mt->db->fetch_permission(array('blog_id' => 0, 'id' => $cmntr['author_id']));
    if (!empty($perms)) {
        $perms = $perms[0];
        if (strstr($perms['permission_permissions'], '\'administer\''))
            return true;
    }

    if (intval($ctx->mt->config['singlecommunity']))
        $blog_id = 0;

    // commenter has permission?
    $perms = $ctx->mt->db->fetch_permission(array('blog_id' => $blog_id, 'id' => $cmntr['author_id']));
    if (!empty($perms))
        return false;
    $perms = $perms[0];
    if (strstr($perms['permission_restrictions'], "'comment'"))
        return false;
    elseif (strstr($perms['permission_permissions'], "'comment'") || strstr($perms['permission_permissions'], "'manage_feedback'"))
        return true;
    else
        return false;
}
