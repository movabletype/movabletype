<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtassets($args, $content, &$ctx, &$repeat) {
    $localvars = array('_assets', 'asset', 'asset_first_in_row', 'asset_last_in_row');
    $counter = 0;

    if (isset($args['sort_by']) && $args['sort_by'] == 'score' && !isset($args['namespace'])) {
        return $ctx->error($ctx->mt->translate('sort_by="score" must be used in combination with namespace.'));
    }

    if (!isset($content)) {
        $ctx->localize($localvars);
        $blog_id = $ctx->stash('blog_id');
        $args['blog_id'] = $ctx->stash('blog_id');
        $tag = $ctx->this_tag();
        if (($tag == 'mtentryassets') || ($tag == 'mtpageassets')) {
            $entry = $ctx->stash('entry');
            if ($entry) $args['entry_id'] = $entry['entry_id'];
        }
        $args['exclude_thumb'] = 1;

        $assets = $ctx->mt->db->fetch_assets($args);
        $ctx->stash('_assets', $assets);
    } else {
        $assets = $ctx->stash('_assets');
        $counter = $ctx->stash('_assets_counter');
    }

    if ($counter < count($assets)) {
        $per_row = 1;
        if (isset($args['assets_per_row']))
            $per_row = $args['assets_per_row'];
        $asset = $assets[$counter];
        $ctx->stash('asset',  $asset);
        $ctx->stash('_assets_counter', $counter + 1);
        $ctx->stash('asset_first_in_row', ($counter % $per_row) == 0);
        $ctx->stash('asset_last_in_row', (($counter + 1) % $per_row) == 0);
        if (($counter + 1) >= count($assets))
            $ctx->stash('asset_last_in_row', true);

        $repeat = true;
        $count = $counter + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($assets));
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }

    return $content;
}
?>

