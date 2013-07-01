<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtwebsitelabel.php 4196 2009-09-04 07:46:50Z takayama $

function smarty_function_mtwebsitethemeid($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    if (empty($blog)) return '';
    $website = $blog->is_blog() ? $blog->website() : $blog;
    if (empty($website)) return '';
    $id = $website->blog_theme_id;
    $id = str_replace ('_', '-', $id);
    return $id;
}
?>
