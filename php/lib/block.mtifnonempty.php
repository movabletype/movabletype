<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifnonempty($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: tag
    if (!isset($content)) {
        $ctx->localize(array('conditional', 'else_content'));
        if (isset($args['tag'])) {
            $tag = $args['tag'];
            $tag = preg_replace('/^mt:?/i', '', $tag);
            $largs = $args; // local arguments without 'tag' element
            unset($largs['tag']);
            $output = $ctx->tag($tag, $largs);
        } elseif (isset($args['name'])) {
            $output = $ctx->__stash['vars'][$args['name']];
        } elseif (isset($args['var'])) {
            $output = $ctx->__stash['vars'][$args['var']];
        }
        $ctx->stash('conditional', (isset($output) && strlen($output)));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('conditional', 'else_content'));
    }
    return $content;
}
?>
