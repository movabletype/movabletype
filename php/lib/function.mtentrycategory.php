<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentrycategory($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (empty($entry))
        return '';

    $cat = $entry->category();
    if ($cat) {
        return $cat->category_label;
    }

    return '';
}
?>
