<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtassets($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('_assets', 'asset', 'asset_first_in_row', 'asset_last_in_row', 'conditional', 'else_content', 'blog', 'blog_id'), common_loop_vars());
    $counter = 0;

    if (isset($args['sort_by']) && $args['sort_by'] == 'score' && !isset($args['namespace'])) {
        return $ctx->error($ctx->mt->translate('sort_by="score" must be used together with a namespace.'));
    }

    if (!isset($content)) {
        $ctx->localize($localvars);

        require_once('multiblog.php');
        multiblog_block_wrapper($args, $content, $ctx, $repeat);

        $blog_id = $ctx->stash('blog_id');
        $args['blog_id'] = $ctx->stash('blog_id');
        $tag = $ctx->this_tag();
        if (($tag == 'mtentryassets') || ($tag == 'mtpageassets')) {
            $entry = $ctx->stash('entry');
            if ($entry) $args['entry_id'] = $entry->entry_id;
        }
        $args['exclude_thumb'] = 1;

        $ts = $ctx->stash('current_timestamp');
        $tse = $ctx->stash('current_timestamp_end');
        if ($ts && $tse) {
            $args['current_timestamp'] = $ts;
            $args['current_timestamp_end'] = $tse;
        }

        $assets = $ctx->mt->db()->fetch_assets($args);
        $ctx->stash('_assets', $assets);
    } else {
        $assets = $ctx->stash('_assets');
        $counter = $ctx->stash('_assets_counter');
    }

    $ctx->stash('conditional', empty($assets) ? 0 : 1);
    if (empty($assets)) {
        $ret = $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
        if (!$repeat)
              $ctx->restore($localvars);
        return $ret;
    }

    if ($counter < count($assets)) {
        $blog_id = $ctx->stash('blog_id');
        $per_row = 1;
        if (isset($args['assets_per_row']))
            $per_row = $args['assets_per_row'];
        $asset = $assets[$counter];
        $ctx->stash('asset',  $asset);
        $ctx->stash('_assets_counter', $counter + 1);
        $ctx->stash('asset_first_in_row', ($counter % $per_row) == 0);
        $ctx->stash('asset_last_in_row', (($counter + 1) % $per_row) == 0);
        if ( $asset->asset_blog_id != $blog_id) {
            $ctx->stash('blog_id', $asset->asset_blog_id);
            $ctx->stash('blog', $asset->blog() );
        }
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
