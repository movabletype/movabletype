<?php
function smarty_block_mtentryauthoruserpicasset($args, $content, &$ctx, &$repeat) {
    $entry = $ctx->stash('entry');
    if (!$entry) {
        return $ctx->error("No entry available");
    }

    $author = $ctx->mt->db->fetch_author($entry['entry_author_id']);
    if (!$author) return '';

    $asset = $ctx->mt->db->fetch_assets(array('asset_id' => $author['author_userpic_asset_id']));
    if (!$asset) return '';

    $ctx->stash('asset',  $asset[0]);

    return $content;
}
?>
