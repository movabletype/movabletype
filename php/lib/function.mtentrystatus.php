<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

define('STATUS_HOLD', 1);
define('STATUS_RELEASE', 2);
define('STATUS_REVIEW', 3);
define('STATUS_FUTURE', 4);

function status_text($s) {
    // TODO: translations of these statuses
    return $s == STATUS_HOLD ? "Draft" :
        ($s == STATUS_RELEASE ? "Publish" :
            ($s == STATUS_REVIEW ? "Review" :
                ($s == STATUS_FUTURE ? "Future" : '')));
}

function smarty_function_mtentrystatus($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return status_text($entry['entry_status']);
}
?>
