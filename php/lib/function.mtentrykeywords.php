<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentrykeywords($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry->entry_keywords;
}
?>
