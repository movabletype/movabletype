<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtindexlink($args, &$ctx) {
    $tmpl = $ctx->stash('index_templates');
    $counter = $ctx->stash('index_templates_counter');
    $idx = $tmpl[$counter];
    if (!$idx) return '';

    $blog = $ctx->stash('blog');
    $site_url = $blog->site_url();
    if (!preg_match('!/$!', $site_url)) $site_url .= '/';
    $link = $site_url . $idx->template_outfile;
    if (empty($args['with_index'])) {
        $link = _strip_index($link, $blog);
    }
    return $link;
}
?>
