<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtassetiftagged($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $asset = $ctx->stash('asset');
        if ($asset) {
            $asset_id = $asset->asset_id;
            $include_private = empty($args['include_private']) ? 0 : 1;
            $tag = $args['name'];
            $tag or $tag = $args['tag'];
            $targs = array('asset_id' => $asset_id, 'include_private' => $include_private);
            if ($tag) {
                $targs['tags'] = $tag;
                if (substr($tag,0,1) == '@') {
                    $targs['include_private'] = 1;
                }
            }
            $tags = $ctx->mt->db()->fetch_asset_tags($targs);
            $has_tag = count($tags) > 0;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_tag);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
