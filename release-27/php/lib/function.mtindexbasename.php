<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtindexbasename($args, &$ctx) {
    $name = $ctx->mt->config('IndexBasename');
    if (!isset($args['extension']) || !$args['extension']) return $name;
    $blog = $ctx->stash('blog');
    $ext = $blog['blog_file_extension'];
    if ($ext) $ext = '.' . $ext;
    return $name . $ext;
}
?>
