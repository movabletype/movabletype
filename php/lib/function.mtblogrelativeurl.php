<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtblogrelativeurl($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    $host = $blog['blog_site_url'];
    if (!preg_match('!/$!', $host))
        $host .= '/';

    if (preg_match('!^https?://[^/]+(/.*)$!', $host, $matches))
        return $matches[1];
    else
        return '';
}
?>
