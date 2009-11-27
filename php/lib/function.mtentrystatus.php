<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function status_text($s) {
    $status = array(
        1 => "Draft",    # STATUS_HOLD
        2 => "Publish",  # STATUS_RELEASE
        3 => "Review",   # STATUS_REVIEW
        4 => "Future"    # STATUS_FUTURE
    );

    $mt = MT::get_instance();
    return $mt->translate($status[$s]);
}

function smarty_function_mtentrystatus($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return status_text($entry->entry_status);
}
?>
