<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentrytrackbacklink.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtentrytrackbacklink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    $tb = $entry->trackback();
    if (!$tb) return '';
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $path .= $ctx->mt->config('TrackbackScript') . '/' . $tb->trackback_id;
    return $path;
}
?>
