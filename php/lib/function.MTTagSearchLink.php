<?php
function smarty_function_MTTagSearchLink($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    $blog_id = $ctx->stash('blog_id');
    if (!$tag) return '';
    if (is_array($tag)) {
        $name = $tag['tag_name'];
    } else {
        $name = $tag;
    }
    require_once "function.MTCGIPath.php";
    $search = smarty_function_MTCGIPath($args, $ctx);
    $search .= $ctx->mt->config['SearchScript'];
    return $search . '?tag=' . urlencode($name) . '&amp;blog_id=' . $blog_id;
}
?>
