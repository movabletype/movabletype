<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtindexlist($args, $content, &$ctx, &$repeat) {
    $localvars = array('index_templates', 'index_templates_counter');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $tmpl = $ctx->mt->db->fetch_templates(array(
            type => 'index',
            blog_id => $ctx->stash('blog_id')
        ));
        $counter = 0;
        $ctx->stash('index_templates', $tmpl);
    } else {
        $tmpl = $ctx->stash('index_templates');
        $counter = $ctx->stash('index_templates_counter') + 1;
    }
    if ($counter < count($tmpl)) {
        $ctx->stash('index_templates_counter', $counter);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}
?>
