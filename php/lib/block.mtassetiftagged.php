<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtassetiftagged($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $asset = $ctx->stash('asset');
        if ($asset) {
            $asset_id = $asset->asset_id;
            $include_private = empty($args['include_private']) ? 0 : 1;
            $tag = isset($args['name']) ? $args['name'] : null;
            $tag or $tag = isset($args['tag']) ? $args['tag'] : null;
            $targs = array('asset_id' => $asset_id, 'include_private' => $include_private);
            if ($tag) {
                $targs['tags'] = $tag;
                if (substr($tag,0,1) == '@') {
                    $targs['include_private'] = 1;
                }
            }
            $tags = $ctx->mt->db()->fetch_asset_tags($targs);
            $has_tag = is_array($tags) && count($tags) > 0;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_tag);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
