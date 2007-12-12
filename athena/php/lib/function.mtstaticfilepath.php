<?php
function smarty_function_mtstaticfilepath($args, &$ctx) {
    $path = $ctx->mt->config('StaticFilePath');
    if (!$path) {
        $path = dirname(dirname(dirname(__FILE__)));
        $path .= DIRECTORY_SEPARATOR . 'mt-static' . DIRECTORY_SEPARATOR;
    }
    if (substr($path, strlen($path) - 1, 1) != DIRECTORY_SEPARATOR)
        $path .= DIRECTORY_SEPARATOR;
    return $path;
}
?>
