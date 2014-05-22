<?php
# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtasseturl($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';
    $blog = $ctx->stash('blog');

    $url = $asset->asset_url;

    $site_url = $blog->site_url();
    $site_url = preg_replace('/\/$/', '', $site_url);
    $url = preg_replace('/^%r/', $site_url, $url);

    require_once('function.mtstaticwebpath.php');
    $static_url = smarty_function_mtstaticwebpath($args, $ctx);
    $url = preg_replace('/^%s\//', $static_url, $url);

    $archive_url = $blog->archive_url();
    if ($archive_url) {
        $archive_url = preg_replace('/\/$/', '', $archive_url);
        $url = preg_replace('/^%a/', $archive_url, $url);
    }

    return $url;
}
?>
