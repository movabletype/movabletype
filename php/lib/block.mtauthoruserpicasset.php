<?php
function smarty_block_mtauthoruserpicasset($args, $content, &$ctx, &$repeat) {
    $author = $ctx->stash('author');
    if (!$author) {
        return $ctx->error("No author available");
    }

    $asset_id = isset($author['author_userpic_asset_id']) ? $author['author_userpic_asset_id'] : 0;
    $asset = $ctx->mt->db->fetch_assets(array('id' => $asset_id));
    if (!$asset) return '';

    $ctx->stash('asset',  $asset[0]);

    return $content;
}
?>
