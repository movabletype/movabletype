<?php
function smarty_block_mtcommenteruserpicasset($args, $content, &$ctx, &$repeat) {
    $comment = $ctx->stash('comment');
    if (!$comment) {
        return $ctx->error("No comment available");
    }
    $cmntr = $ctx->stash('commenter');
    if (!$cmntr) return '';

    $asset = $ctx->mt->db->fetch_assets(array('asset_id' => $cmntr['author_userpic_asset_id']));
    if (!$asset) return '';

    $ctx->stash('asset',  $asset[0]);

    return $content;
}
?>
