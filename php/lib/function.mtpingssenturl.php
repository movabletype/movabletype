<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtpingssenturl($args, &$ctx) {
    $url = $ctx->stash('ping_sent_url');
    return $url;
}
?>
