<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtarchivecategory.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtarchivecategory($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        require_once("function.mtcategorylabel.php");
        return smarty_function_mtcategorylabel($args, $ctx);
    }

    $cat = $ctx->stash('archive_category');
    return $cat ? $cat->category_label : '';
}
?>
