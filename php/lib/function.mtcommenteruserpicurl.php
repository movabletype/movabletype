<?php
function smarty_function_mtcommenteruserpicurl($args, &$ctx) {
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
    $userpic_url = userpic_url($asset[0], $blog, $cmntr);
    return $userpic_url;
}
?>
