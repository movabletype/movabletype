<?php
function smarty_function_MTCGIRelativeURL($args, &$ctx) {
    // status: complete
    // parameters: none
    $url = $ctx->mt->config['CGIPath'];
    if (substr($url, strlen($url) - 1, 1) != '/')
        $url .= '/';
    if (preg_match('!^(?:https?://[^/]+)?(/.*)$!', $url, $matches)) {
        return $matches[1];
    } else {
        return $url;
    }
}
?>
