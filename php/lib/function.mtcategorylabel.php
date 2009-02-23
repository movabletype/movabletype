<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcategorylabel($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) {
        if ($e = $ctx->stash('entry')) {
            if ($cat_id = $e['placement_category_id']) {
                $cat = $ctx->mt->db->fetch_category($cat_id);
            }
        }
    }
    if (!$cat) return '';
    return $cat['category_label'];
}
