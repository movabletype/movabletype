<?php
function smarty_function_mtentrytrackbacklink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    if (!$entry['trackback_id']) return '';
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $path .= $ctx->mt->config('TrackbackScript') . '/' . $entry['trackback_id'];
    return $path;
}
?>
