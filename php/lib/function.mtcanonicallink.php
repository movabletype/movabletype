<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
function smarty_function_mtcanonicallink($args, &$ctx) {
    $url = $ctx->tag('canonicalurl', $args);
    if (empty($url)) {
        return '';
    }

    return '<link rel="canonical" href="' . encode_html($url) . '" />';
}
