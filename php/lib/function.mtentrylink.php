<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentrylink.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtentrylink($args, &$ctx) {
    $args['no_anchor'] = 1;
    $link = $ctx->tag('EntryPermalink', $args);
    if ($args['with_index'] && preg_match('/\/(#.*)$/', $link)) {
        $blog = $ctx->stash('blog');
        $index = $ctx->mt->config('IndexBasename');
        $ext = $blog->blog_file_extension;
        if ($ext) $ext = '.' . $ext; 
        $index .= $ext;
        $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
    }
    return $link;
}
?>
