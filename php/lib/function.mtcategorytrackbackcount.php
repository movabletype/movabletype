<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcategorytrackbackcount($args, &$ctx) {
    $cat = $ctx->stash('category');
    $cat_id = $cat['category_id'];
    $count = $ctx->mt->db->category_ping_count($cat_id);
    return $ctx->count_format($count, $args);
}
