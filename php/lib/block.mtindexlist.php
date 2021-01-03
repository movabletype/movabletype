<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtindexlist($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('index_templates', 'index_templates_counter', 'template'), common_loop_vars());
    if (!isset($content)) {
        $ctx->localize($localvars);
        $tmpl = $ctx->mt->db()->fetch_templates(array(
            'type' => 'index',
            'blog_id' => $ctx->stash('blog_id')
        ));
        $counter = 0;
        $ctx->stash('index_templates', $tmpl);
    } else {
        $tmpl = $ctx->stash('index_templates');
        $counter = $ctx->stash('index_templates_counter') + 1;
    }
    if (is_array($tmpl) && $counter < count($tmpl)) {
        $ctx->__stash['vars']['__counter__'] = $counter + 1;
        $ctx->__stash['vars']['__odd__'] = ($counter % 2) == 0;
        $ctx->__stash['vars']['__even__'] = ($counter % 2) == 1;
        $ctx->__stash['vars']['__first__'] = $counter == 0;
        $ctx->__stash['vars']['__last__'] = count($tmpl) == $counter + 1;
        $ctx->stash('index_templates_counter', $counter);
        $ctx->stash('template', $tmpl[$counter]);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}
?>
