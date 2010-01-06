<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentryauthorlink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) return '';

    $type = $args['type'];
    $displayname = encode_html( $entry->author()->nickname );
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
    $target = $args['new_window'] ? ' target="_blank"' : '';
    if (!$type) {
        if ($show_url && $entry->author()->url && ($displayname != '')) {
            $type = 'url';
        } elseif ($show_email && $entry->author()->email && ($displayname != '')) {
            $type = 'email';
        }
    }
    if ($type == 'url') {
        if ($entry->author()->url && ($displayname != '')) {
            return sprintf('<a href="%s"%s>%s</a>', encode_html( $entry->author()->url ), $target, $displayname);
        }
    } elseif ($type == 'email') {
        if ($entry->author()->email && ($displayname != '')) {
            $str = "mailto:" . encode_html( $entry->author()->email );
            if ($args['spam_protect'])
                $str = spam_protect($str);
            return sprintf('<a href="%s">%s</a>', $str, $displayname);
        }
    } elseif ($type == 'archive') {
        require_once("function.mtarchivelink.php");
        $link = smarty_function_mtarchivelink(array('type' => 'Author'), $ctx);
        if ($link) {
            return sprintf('<a href="%s"%s>%s</a>', $link, $target, $displayname);
        }
    }
    return $displayname;
}
