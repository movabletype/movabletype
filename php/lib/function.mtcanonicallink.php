<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
function smarty_function_mtcanonicallink($args, &$ctx) {
    $url = $ctx->tag('canonicalurl', $args);
    if (empty($url)) {
        return '';
    }

    return '<link rel="canonical" href="' . encode_html($url) . '" />';
}
