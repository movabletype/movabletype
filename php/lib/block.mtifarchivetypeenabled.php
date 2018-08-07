<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifarchivetypeenabled($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $at = $args['type'];
        $at or $at = $args['archive_type'];
        $at = preg_quote($at);
        $blog_at = ',' . $blog->blog_archive_type . ',';
        $enabled = 0;
        $at_exists = preg_match("/,$at,/", $blog_at);
        if ($at_exists) {
            $maps = $ctx->mt->db()->fetch_templatemap(
                array('type' => $at, 'blog_id' => $blog->blog_id, 'content_type' => $args['content_type']));
            if (!empty($maps)) {
                foreach ($maps as $map) {
                    if ($map->templatemap_build_type != 0 )
                        $enabled = 1; /* was $enabled++; */
                }
            }
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $enabled);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
