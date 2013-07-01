<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtwebsiteid($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    if (empty($blog)) return 0;
    $website = $blog->is_blog() ? $blog->website() : $blog;
    if (empty($website)) return '';
    return $website->id;
}
?>
