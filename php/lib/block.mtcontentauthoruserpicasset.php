<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcontentauthoruserpicasset($args, $content, &$ctx, &$repeat) {
    $content_data = $ctx->stash('content');
    if (!isset($content_data))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentAuthorUserpicAsset" ));

    $author = $content_data->author();
    if (!$author) return '';

    $asset = $author->userpic();
    if (!$asset) return '';

    $ctx->stash('asset',  $asset);

    return $content;
}
?>
