<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mttagcount.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mttagcount($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    $count = 0;
    if ($tag && is_object($tag))
        $count = $tag->tag_count;
    return $ctx->count_format($count, $args);
}
