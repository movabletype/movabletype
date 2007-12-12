<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentrytrackbackcount($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $entry_id = $entry['entry_id'];
    return $ctx->mt->db->entry_ping_count($entry_id);
}
?>