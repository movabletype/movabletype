<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtauthorhasentry($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $author = $ctx->stash('author');
        if (!$author) {
            return $ctx->error($ctx->mt->translate("No author available"));
        }
        $args['blog_id'] = $ctx->stash('blog_id');
        $args['author_id'] = $author['author_id'];
        $args['class'] = 'entry';
        $count = $ctx->mt->db->author_entry_count($args);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $count);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
