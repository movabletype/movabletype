<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
