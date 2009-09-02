<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcategorycommentcount.php 106007 2009-07-01 11:33:43Z ytakayama $

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
