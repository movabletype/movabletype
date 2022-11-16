<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtfor($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('__for_end', '__for_var', '__out', '__for_increment'), common_loop_vars());

    if (!isset($content)) {
        $ctx->localize($localvars);
        // first invocation; setup loop
        $start = array_key_exists('start', $args) ?
            $args['start']
            : (array_key_exists('from', $args) ?
               $args['from']
               : 0);
        $end = array_key_exists('end', $args) ? $args['end']
            : (array_key_exists('to', $args) ? $args['to'] : null);
        $var = isset($args['var']) ? $args['var'] : null;

        if ($end === null) {
            $content = '';
            $repeat = false;
        }

        $index = $start;
        $counter = 1;
        $ctx->stash('__for_end', $end);
        $ctx->stash('__for_var', $var);
        $ctx->stash('__out', false);
        $ctx->stash('__for_increment', isset($args['increment']) ? $args['increment'] : 1);
    } else {
        $inc = $ctx->stash('__for_increment');
        $index = $ctx->__stash['vars']['__index__'] + $inc;
        $counter = $ctx->__stash['vars']['__counter__'] + 1;
        $end = $ctx->stash('__for_end');
        $var = $ctx->stash('__for_var');
        $out = $ctx->stash('__out');
    }

    if ($index <= $end) {
        $ctx->__stash['vars']['__index__'] = $index;
        $ctx->__stash['vars']['__counter__'] = $counter;
        $ctx->__stash['vars']['__odd__'] = ($counter % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($counter % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $counter == 1;
        $ctx->__stash['vars']['__last__'] = $index == $end;
        if ($var)
            $ctx->__stash['vars'][$var] = $index;
        if (isset($args['glue']) && !empty($content)) {
            if ($out)
                $content = $args['glue'] . $content;
            else
                $ctx->stash('__out', true);
        }
        $repeat = true;
    } else {
        if (isset($args['glue']) && $out && !empty($content))
            $content = $args['glue'] . $content;
        $ctx->restore($localvars);
        $repeat = false;
    }

    return $content;
}
?>
