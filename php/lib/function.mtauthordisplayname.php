<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtauthordisplayname($args, &$ctx) {
    // status: complete
    // parameters: none
    $author = $ctx->stash('author');
    if (empty($author)) {
        $entry = $ctx->stash('entry');
        if (!empty($entry)) {
            $author = $ctx->mt->db->fetch_author($entry['entry_author_id']);
        }
    }
    if (empty($author)) {
        return $ctx->error("No author available");
    }
    $author_name = $author['author_nickname'];
    $author_name or $author_name =
        $ctx->mt->translate('(Display Name not set)');
    return $author_name;
}
?>
