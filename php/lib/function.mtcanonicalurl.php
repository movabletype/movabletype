<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
function smarty_function_mtcanonicalurl($args, &$ctx) {
    $blog = $ctx->stash('blog');

    if (empty($args['current_mapping'])) {
        $url = $ctx->stash('preferred_mapping_url');
    }
    if (empty($url)) {
        $url = $ctx->stash('current_mapping_url');
    }
    if (empty($url)) {
        return '';
    }

    return empty($args['with_index']) ? _strip_index($url, $blog) : $url;
}
