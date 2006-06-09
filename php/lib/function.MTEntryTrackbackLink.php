<?php
function smarty_function_MTEntryTrackbackLink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    if (!$entry['trackback_id']) return '';
    require_once "function.MTCGIPath.php";
    $path = smarty_function_MTCGIPath($args, $ctx);
    $path .= $ctx->mt->config['TrackbackScript'] . '/' . $entry['trackback_id'];
    return $path;
}
?>
