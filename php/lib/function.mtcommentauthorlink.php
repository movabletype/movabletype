<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentauthorlink($args, &$ctx) {
    $comment = $ctx->stash('comment');
    $name = $comment['comment_author'];
    if (!$name && isset($args['default_name'])) {
        $name = $args['default_name'];
    }
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
    if ($show_url && $url) {
        require_once "function.mtcgipath.php";
        $cgi_path = smarty_function_mtcgipath($args, $ctx);
        $comment_script = $ctx->mt->config('CommentScript');
        $name = strip_tags($name);
        $url = strip_tags($url);
        $url = preg_replace('/>/', '&gt;', $url);
        if ($comment['comment_id'] && !isset($args['no_redirect'])) {
            return sprintf('<a title="%s" href="%s%s?__mode=red;id=%d">%s</a>', $url, $cgi_path, $comment_script, $comment['comment_id'], $name);
        } else {
            return sprintf('<a title="%s" href="%s">%s</a>', $url, $url, $name);
        }
    } elseif ($show_email && $email && is_valid_email($email)) {
        $email = strip_tags($email);
        $str = 'mailto:' . $email;
        if ($args['spam_protect']) {
            $str = spam_protect($str);
        }
        return sprintf('<a href="%s">%s</a>', $str, $name);
    } else {
        $cmntr = $ctx->stash('commenter');
        if (isset($cmntr)) {
            if (isset($comment['comment_commenter_id'])) {
                $cmntr = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);
            }
            if ($cmntr && $cmntr['author_url']) {
                return sprintf('<a title="%s" href="%s">%s</a>', $cmntr['author_url'], $cmntr['author_url'], $name);
            }
        }
        
        return $name;
    }
}
?>
