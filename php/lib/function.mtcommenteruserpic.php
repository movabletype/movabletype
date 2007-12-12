<?php
function smarty_function_mtcommenteruserpic($args, &$ctx) {
    $comment = $ctx->stash('comment');
    if (!$comment) {
        return $ctx->error("No comment available");
    }
    $cmntr = $ctx->stash('commenter');
    if (!$cmntr) return '';

    $asset = $ctx->mt->db->fetch_assets(array('asset_id' => $cmntr['author_userpic_asset_id']));
    if (!$asset) return '';

    $blog =& $ctx->stash('blog');

    require_once("MTUtil.php");
    $asset_url = asset_url($asset[0]['asset_url'], $blog);
    $asset_path = asset_path($asset[0]['asset_file_path'], $blog);
    list($src_w, $src_h, $src_type, $src_attr) = getimagesize($asset_path);
    $dimensions = sprintf('width="%s" height="%s"', $src_w, $src_h);

    $link =sprintf('<img src="%s" %s alt="%s" />',
                   encode_html($asset_url), $dimensions, encode_html($asset['label']));

    return $link;
}
?>
