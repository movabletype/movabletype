<?php
function smarty_function_MTCGIHost($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once "function.MTCGIPath.php";
    $path = smarty_function_MTCGIPath($args, $ctx);
    if (preg_match('/^https?:\/\/([^\/:]+)(:\d+)?\//', $path, $matches))
        return $args['exclude_port'] ? $matches[1] : $matches[1] . $matches[2];
    return '';
}
?>
