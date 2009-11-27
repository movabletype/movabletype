<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentauthor($args, &$ctx) {
    $c = $ctx->stash('comment');
    if (!$c)
        return $ctx->error("No comment available");
    $a = isset($c->comment_author) ? $c->comment_author : '';
    if ($c->comment_commenter_id) {
        $commenter = $ctx->stash('commenter');
        if ($commenter)
            $a = $commenter->nickname;
    }
    if (isset($args['default']))
        $a or $a = $args['default'];
    else {
        $mt = MT::get_instance();
        $a or $a = $mt->translate("Anonymous");
    }
    $a or $a = '';
    return strip_tags($a);
}
