<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentauthorlink($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentAuthorLink" ));

    $author = $content->author();

    $type = isset($args['type']) ? $args['type'] : null;
    $displayname = encode_html( $author->author_nickname );
    if (isset($args['show_email']))
        $show_email = $args['show_email'];
    else
        $show_email = 0;
    if (isset($args['show_url']))
        $show_url = $args['show_url'];
    else
        $show_url = 1;

    require_once("MTUtil.php");
    # Open the link in a new window if requested (with new_window="1").
    $target = !empty($args['new_window']) ? ' target="_blank"' : '';
    if (!$type) {
        if ($show_url && $author->author_url && ($displayname != '')) {
            $type = 'url';
        } elseif ($show_email && $author->author_email && ($displayname != '')) {
            $type = 'email';
        }
    }
    if ($type == 'url') {
        if ($author->author_url && ($displayname != '')) {
            $hcard = !empty($args['show_hcard']) ? ' class="fn url"' : '';
            return sprintf('<a%s href="%s"%s>%s</a>', $hcard, encode_html( $author->author_url ), $target, $displayname);
        }
    } elseif ($type == 'email') {
        if ($author->author_email && ($displayname != '')) {
            $str = "mailto:" . encode_html( $author->author_email );
            if (!empty($args['spam_protect']))
                $str = spam_protect($str);
            $hcard = !empty($args['show_hcard']) ? ' class="fn email"' : '';
            return sprintf('<a%s href="%s">%s</a>', $hcard, $str, $displayname);
        }
    } elseif ($type == 'archive') {
        if ($author->type == 1) { # MT::Author::AUTHOR()
            require_once("function.mtarchivelink.php");
            $link = smarty_function_mtarchivelink(array('type' => 'ContentType-Author'), $ctx);
            if ($link) {
                return sprintf('<a href="%s"%s>%s</a>', $link, $target, $displayname);
            }
        }
    }
    return $displayname;
}
?>
