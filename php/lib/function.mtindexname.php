<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtindexname.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtindexname($args, &$ctx) {
    $tmpl = $ctx->stash('index_templates');
    $counter = $ctx->stash('index_templates_counter');
    $idx = $tmpl[$counter];
    if (!$idx) return '';
    return $idx->template_name;
}
?>
