<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifarchivetypeenabled($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $at = $args['type'];
        $at or $at = $args['archive_type'];
        $at = preg_quote($at);
        $blog_at = ',' . $blog['blog_archive_type'] . ',';
        $enabled = preg_match("/,$at,/", $blog_at);
        $map = $ctx->mt->db->fetch_templatemap(
            array('type' => $at, 'blog_id' => $blog['blog_id']));
        if (empty($map))
            $enabled = 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $enabled);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
