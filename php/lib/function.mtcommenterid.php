<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommenterid($args, &$ctx) {
    $comment = $ctx->stash('comment');
    if (!$comment) return '';
    $cmntr = $ctx->stash('commenter');
    if (!$cmntr) return '';
    return $cmntr['author_id'];
}
?>