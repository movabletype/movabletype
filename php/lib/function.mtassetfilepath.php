<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtassetfilepath.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_function_mtassetfilepath($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    $blog = $ctx->stash('blog');

    $asset_file = $asset->asset_file_path;

    $blog_site_path = $blog->site_path();
    $blog_site_path = preg_replace('/\/$/', '', $blog_site_path);
    $asset_file = preg_replace('/^%a/', $blog_site_path, $asset_file);

    require_once('MTUtil.php');
    $static_path = static_file_path();
    $asset_file = preg_replace('/^%s/', $static_path, $asset_file);    

    $blog_archive_path = $blog->archive_path();
    if (!$blog_archive_path) $blog_archive_path = $blog_site_path;
    if ($blog_archive_path) {
        $blog_archive_path = preg_replace('/\/$/', '', $blog_archive_path);
        $asset_file = preg_replace('/^%r/', $blog_archive_path, $asset_file);
    }

    return $asset_file;
}
?>
