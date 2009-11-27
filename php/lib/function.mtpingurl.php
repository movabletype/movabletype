<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtpingurl($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping->tbping_source_url;
}
?>
