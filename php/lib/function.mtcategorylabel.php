<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcategorylabel.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtcategorylabel($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) {
        if ($e = $ctx->stash('entry')) {
            $cat = $e->category();
        }
    }
    if (!$cat) return '';
    return $cat->category_label;
}
