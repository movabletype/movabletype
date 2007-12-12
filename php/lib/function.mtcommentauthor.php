<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentauthor($args, &$ctx) {
    $c = $ctx->stash('comment');
    if (!$c) {
        return $ctx->error("No comment available");
    }
    $a = isset($c['comment_author']) ? $c['comment_author'] : '';
    if (isset($args['default'])) {
        $a or $a = $args['default'];
    }
    $a or $a = '';
    return strip_tags($a);
}
?>
