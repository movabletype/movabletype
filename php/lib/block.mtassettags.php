<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtassettags($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('_tags', 'Tag', '_tags_counter', 'tag_min_count', 'tag_max_count','all_tag_count', '__out', 'class_type'), common_loop_vars());
    if (!isset($content)) {
        $ctx->localize($localvars);
        require_once("MTUtil.php");
        $asset = $ctx->stash('asset');
        $blog_id = $asset->asset_blog_id;
        $include_private = empty($args['include_private']) ? 0 : 1;

        $tags = $ctx->mt->db()->fetch_asset_tags(array('asset_id' => $asset->asset_id, 'blog_id' => $blog_id, 'include_private' => $include_private));
        if (!is_array($tags)) $tags = array();
        $ctx->stash('_tags', $tags);
        $ctx->stash('__out', false);
        $ctx->stash('class_type', 'asset');
        
        $counter = 0;
    } else {
        $tags = $ctx->stash('_tags');
        $counter = $ctx->stash('_tags_counter');
        $out = $ctx->stash('__out');
    }
    if (is_array($tags) && $counter < count($tags)) {
        $tag = $tags[$counter];
        $ctx->stash('Tag', $tag);
        $ctx->stash('_tags_counter', $counter + 1);
        $ctx->__stash['vars']['__counter__'] = $counter + 1;
        $ctx->__stash['vars']['__odd__'] = ($counter % 2) == 0;
        $ctx->__stash['vars']['__even__'] = ($counter % 2) == 1;
        $ctx->__stash['vars']['__first__'] = $counter == 0;
        $ctx->__stash['vars']['__last__'] = count($tags) == $counter + 1;
        $repeat = true;
        if (isset($args['glue']) && !empty($content)) {
            if ($out)
                $content = $args['glue'] . $content;
            else
                $ctx->stash('__out', true);
        }
    } else {
        if (isset($args['glue']) && $out && !empty($content))
            $content = $args['glue'] . $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
