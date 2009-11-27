<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtblogname.php 4196 2009-09-04 07:46:50Z takayama $

function smarty_function_mtblogthemeid($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    $id = $blog->blog_theme_id;
    $id = str_replace ('_', '-', $id);
    return $id;
}
?>
