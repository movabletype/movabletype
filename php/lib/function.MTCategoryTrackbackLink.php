<?php
function smarty_function_MTCategoryTrackbackLink($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    if (!$cat['trackback_id']) return '';
    require_once "function.MTCGIPath.php";
    $path = smarty_function_MTCGIPath($args, $ctx);
    $path .= $ctx->mt->config['TrackbackScript'] . '/' . $cat['trackback_id'];
    return $path;
}
?>
