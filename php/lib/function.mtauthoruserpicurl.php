<?php
function smarty_function_mtauthoruserpicurl($args, &$ctx) {
    $author = $ctx->stash('author');
    $asset = $ctx->mt->db->fetch_assets(array('asset_id' => $author['author_userpic_asset_id']));
    if (!$asset) return '';

    $blog =& $ctx->stash('blog');

    require_once("MTUtil.php");
    $userpic_url = userpic_url($asset[0], $blog, $author);
    return $userpic_url;
}
?>
