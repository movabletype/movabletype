<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $author = $ctx->stash('author');
    $author_name = $author['author_nickname'];
    $author_name or $author_name =
        $ctx->mt->translate('(Display Name not set)');
    return $author_name;
}
?>
