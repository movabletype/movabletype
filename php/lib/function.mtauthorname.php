<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtauthorname($args, &$ctx) {
    $author = $ctx->stash('author');
    if (!$author) {
        return $ctx->error("No author available");
    }
    return $author['author_name'];
}
?>
