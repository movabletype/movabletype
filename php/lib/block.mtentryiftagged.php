<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtentryiftagged($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entry = $ctx->stash('entry');
        if ($entry) {
            $entry_id = $entry->entry_id;
            $blog_id = $entry->entry_blog_id;
            $class = $args['class'];
            $include_private = empty($args['include_private']) ? 0 : 1;
            $tag = $args['name'];
            $tag or $tag = $args['tag'];
            $targs = array('entry_id' => $entry_id, 'blog_id' => $blog_id, 'class' => $class, 'include_private' => $include_private);
            if ($tag) {
                $targs['tags'] = $tag;
                if (substr($tag,0,1) == '@') {
                    $targs['include_private'] = 1;
                }
            }
            $tags = $ctx->mt->db()->fetch_entry_tags($targs);
            $has_tag = count($tags) > 0;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_tag);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
