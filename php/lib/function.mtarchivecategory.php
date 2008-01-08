<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtarchivecategory($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        require_once("function.mtcategorylabel.php");
        return smarty_function_mtcategorylabel($args, $ctx);
    }

    $cat = $ctx->stash('archive_category');
    return $cat ? $cat['category_label'] : '';
}
?>
