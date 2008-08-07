<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtfor($args, $content, &$ctx, &$repeat) {
    $localvars = array('__for_end', '__for_var', '__out');

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
        $var = $args['var'];

        if ($end === null) {
            $content = '';
            $repeat = false;
        }

        $index = $start;
        $counter = 1;
        $ctx->stash('__for_end', $end);
        $ctx->stash('__for_var', $var);
        $ctx->stash('__out', false);
    } else {
        $index = $ctx->__stash['vars']['__index__'] + 1;
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
