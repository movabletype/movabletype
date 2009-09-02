<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtindexbasename.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtindexbasename($args, &$ctx) {
    $name = $ctx->mt->config('IndexBasename');
    if (!isset($args['extension']) || !$args['extension']) return $name;
    $blog = $ctx->stash('blog');
    $ext = $blog->blog_file_extension;
    if ($ext) $ext = '.' . $ext;
    return $name . $ext;
}
?>
