<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('stats_lib.php');

function smarty_function_mtstatssnippet($args, &$ctx) {
    $provider = Stats::readied_provider($ctx->stash('blog'));
    if (empty($provider)) {
        return '';
    }

    return $provider->snippet($args, $ctx);
}
