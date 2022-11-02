<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifarchivetypeenabled($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $at = $args['type'] ?? $args['archive_type'] ?? null;
        $at = preg_quote($at);
        if (preg_match('/ContentType/i', $at) && empty($args['content_type'])) {
            $repeat = false;
            return $ctx->error(
              $ctx->mt->translate(
                "You used an [_1] tag without a valid [_2] attribute.",
                array("<MTIfArchiveTypeEnabled>", "content_type")
              )
            );
        }
        $blog_at = ',' . $blog->blog_archive_type . ',';
        $enabled = 0;
        $at_exists = preg_match("/,$at,/", $blog_at);
        if ($at_exists) {
            $params = array('type' => $at, 'blog_id' => $blog->blog_id);
            if ( preg_match('/ContentType/i', $at) ){
                $params['content_type'] = $args['content_type'];
            }
            $maps = $ctx->mt->db()->fetch_templatemap($params);
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
