<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcategorybasename.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtcategorybasename($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    $basename = $cat->category_basename;
    if ($sep = $args['separator']) {
        if ($sep == '-') {
            $basename = preg_replace('/_/', '-', $basename);
        } elseif ($sep == '_') {
            $basename = preg_replace('/-/', '_', $basename);
        }
    }
    return $basename;
}
?>
