<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcategorycommentcount($args, &$ctx) {
    $mt = MT::get_instance();
    $db = $mt->db();
    $category = $ctx->stash('category');
    $cat_id = (int)$category->category_id;
    $count = 0;
    if ($cat_id) {
        $count = $db->category_comment_count(array( 'category_id' => $cat_id ));
    }
    return $ctx->count_format($count, $args);
}
?>
