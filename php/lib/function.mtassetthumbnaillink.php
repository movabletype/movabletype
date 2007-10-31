<?php
function smarty_function_mtassetthumbnaillink($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';
    if ($asset['asset_class'] != 'image') return '';
    $blog = $ctx->stash('blog');
    if (!$blog) return '';

    require_once('MTUtil.php');

    $width = 0;
    $height = 0;
    $scale = 0;

    if (isset($args['width']))
        $width = $args['width'];
    if (isset($args['height']))
        $height = $args['height'];
    if (isset($args['scale']))
        $scale = $args['scale'];

    list($thumb, $thumb_w, $thumb_h) = get_thumbnail_file($asset['asset_id'], $asset['asset_file_path'], $blog['blog_site_path'], $width, $height, $scale);
    if ($thumb != '') {
        global $mt;
        $cache_path = $mt->config('AssetCacheDir');
        $basename = basename($thumb);
        $thumb = $blog['blog_site_url'] . $cache_path . '/' . $basename;
    }

    $target = "";
    if (isset($args['new_window']))
        $target = " target=\"_blank\"";

    return sprintf("<a href=\"%s\"%s><img src=\"%s\" width=\"%d\" height=\"%d\"></a>",
        $asset['asset_url'],
        $target,
        $thumb,
        $thumb_w,
        $thumb_h);
}
?>

