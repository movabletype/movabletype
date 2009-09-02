<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentrytrackbackid.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtentrytrackbackid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $tb = $entry->trackback();
    return $tb->trackback_id;
}
?>
