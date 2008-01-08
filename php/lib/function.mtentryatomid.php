<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentryatomid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['entry_atom_id'];
}
?>
