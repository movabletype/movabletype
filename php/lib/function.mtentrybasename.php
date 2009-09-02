<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentrybasename.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtentrybasename($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    $basename = $entry->entry_basename;
    if ($sep = $args['separator']) {
        if ($sep == '-') {
            $basename = preg_replace('/_/', '-', $basename);
        } elseif ($sep == '_') {
            $basename = preg_replace('/-/', '_', $basename);
        }
    }
    return $basename;
}
