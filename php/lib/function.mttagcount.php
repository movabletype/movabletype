<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mttagcount($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    $count = 0;
    if ($tag && is_array($tag))
        $count = $tag['tag_count'];
    return $ctx->count_format($count, $args);
}
