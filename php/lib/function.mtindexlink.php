<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtindexlink($args, &$ctx) {
    $tmpl = $ctx->stash('index_templates');
    $counter = $ctx->stash('index_templates_counter');
    $idx = $tmpl[$counter];
    if (!$idx) return '';

    $blog = $ctx->stash('blog');
    $site_url = $blog['blog_site_url'];
    if (!preg_match('!/$!', $site_url)) $site_url .= '/';
    $link = $site_url . $idx['template_outfile'];
    if (!$args['with_index']) {
        $link = _strip_index($link, $blog);
    }
    return $link;
}
?>
