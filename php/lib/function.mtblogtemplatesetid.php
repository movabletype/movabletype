<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtblogtemplatesetid.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtblogtemplatesetid($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    if (!$blog) return '';
    $id = $blog->blog_template_set;
    $id = preg_replace('/_/', '-', $id);
    return $id;
}
?>