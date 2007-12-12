<?php
function smarty_function_mtassetthumbnailurl($args, &$ctx) {
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

    list($thumb) = get_thumbnail_file($asset, $blog, $width, $height, $scale);

    return $thumb;
}
?>

