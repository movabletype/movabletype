<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtpagerblock($args, $content, &$ctx, &$repeat) {
    $localvars = array('__out', '__pager_limit', '__pager_count', '__pager_pages', '__first__', '__last__', '__odd__', '__even__', '__value__', '__counter__');

    if (!isset($content)) {
        $ctx->localize($localvars);
        // first invocation; setup loop
        $limit = $ctx->stash('__pager_limit');
        $offset = $ctx->stash('__pager_offset');
        $count = $ctx->stash('__pager_total_count');
        $pages = $limit ? ceil( $count / $limit ) : 1;
        $counter = 1;
        $ctx->stash('__pager_pages', $pages);
        $ctx->stash('__out', false);
    } else {
        $counter = $ctx->__stash['vars']['__counter__'] + 1;
        $limit = $ctx->stash('__pager_limit');
        $offset = $ctx->stash('__pager_offset');
        $count = $ctx->stash('__pager_total_count');
        $pages = $ctx->stash('__pager_pages');
        $out = $ctx->stash('__out');
    }

    if ($counter <= $pages) {
        $ctx->__stash['vars']['__value__'] = $counter;
        $ctx->__stash['vars']['__counter__'] = $counter;
        $ctx->__stash['vars']['__odd__'] = ($counter % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($counter % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $counter == 1;
        $ctx->__stash['vars']['__last__'] = $counter == $pages;
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

