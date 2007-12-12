<?php
function smarty_function_mtcgihost($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    if (preg_match('/^https?:\/\/([^\/:]+)(:\d+)?\//', $path, $matches))
        return $args['exclude_port'] ? $matches[1] : $matches[1] . $matches[2];
    return '';
}
?>
