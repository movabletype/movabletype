<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentryiftagged($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entry = $ctx->stash('entry');
        if ($entry) {
            $entry_id = $entry->entry_id;
            $blog_id = $entry->entry_blog_id;
            $class = isset($args['class']) ? $args['class'] : null;
            $include_private = empty($args['include_private']) ? 0 : 1;
            $tag = isset($args['name']) ? $args['name'] : null;
            $tag or $tag = isset($args['tag']) ? $args['tag'] : null;
            $targs = array('entry_id' => $entry_id, 'blog_id' => $blog_id, 'class' => $class, 'include_private' => $include_private);
            if ($tag) {
                $targs['tags'] = $tag;
                if (substr($tag,0,1) == '@') {
                    $targs['include_private'] = 1;
                }
            }
            $tags = $ctx->mt->db()->fetch_entry_tags($targs);
            $has_tag = is_array($tags) && count($tags) > 0;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_tag);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
