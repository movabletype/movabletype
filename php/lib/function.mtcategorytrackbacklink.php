<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcategorytrackbacklink($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    if (!$cat['trackback_id']) return '';
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $path .= $ctx->mt->config('TrackbackScript') . '/' . $cat['trackback_id'];
    return $path;
}
?>
