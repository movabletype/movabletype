<?php
function smarty_function_MTCGIServerPath($args, &$ctx) {
    // status: complete
    // parameters: none
    $path = $ctx->mt->config['MTDir'];
    if (substr($path, strlen($path) - 1, 1) == '/')
        $path = substr($path, 1, strlen($path)-1);
    return $path;
}
?>
