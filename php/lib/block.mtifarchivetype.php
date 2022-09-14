<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifarchivetype($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $at = $args['type'] ?? $args['archive_type'] ?? null;
        $cat = $ctx->stash('current_archive_type');
        $cat or $at = $ctx->stash('archive_type');
        $same = ($at && $cat) && ($at == $cat);
        if(!$same){
          return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $same);
        }

        $content_type_doesnt_match = 0;
        if (preg_match('/ContentType/i', $at)) {
            if (isset($args['content_type']) && $args['content_type'] !== '' ) {
                $content_type = $ctx->stash('content_type');
                if (isset($content_type)
                    && (   $args['content_type'] === $content_type->content_type_unique_id
                        || $args['content_type'] === strval($content_type->content_type_id)
                        || $args['content_type'] === $content_type->content_type_name )
                    )
                {
                    $same = true;
                }
                else {
                    $same = false;
                }
            } else {
              $repeat = false;
              return $ctx->error(
                $ctx->mt->translate(
                  "You used an [_1] tag without a valid [_2] attribute.",
                  array("<MTIfArchiveType>", "content_type")
                )
              );
            }
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $same);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
