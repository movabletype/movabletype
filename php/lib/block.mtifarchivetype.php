<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifarchivetype($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $at = $args['type'];
        $at or $at = $args['archive_type'];

        $content_type_doesnt_match = 0;
        if (preg_match('/ContentType/i', $at)) {
            if (isset($args['content_type']) && $args['content_type'] !== '' ) {
                $content_type = $ctx->stash('content_type');
                if (isset($content_type)
                    && (   $args['content_type'] === $content_type->content_type_unique_id
                        || $args['content_type'] === $content_type->content_type_id
                        || $args['content_type'] === $content_type->content_type_name )
                    )
                {
                    $content_type_doesnt_match = 0;
                }
                else {
                    $content_type_doesnt_match = 1;
                }
            }
        }

        $cat = $ctx->stash('current_archive_type');
        $cat or $at = $ctx->stash('archive_type');
        $same = ($at && $cat) && ($at == $cat) && !$content_type_doesnt_match;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $same);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
