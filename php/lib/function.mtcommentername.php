<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentername($args, &$ctx) {
    $a =& $ctx->stash('commenter');
    $name = isset($a) ? $a->author_nickname : '';
    if ($name == '') {
        $name = $ctx->tag('CommentName');
    }
    return $name;
}
