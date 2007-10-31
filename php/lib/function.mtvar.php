<?php
function smarty_function_mtvar($args, &$ctx) {
    // status: complete
    // parameters: name
    if (array_key_exists($args['value'])) {
        require_once("function.mtsetvar.php");
        return smarty_function_mtsetvar($args, $ctx);
    }
    $vars =& $ctx->__stash['vars'];
    $value = '';
    $name = $args['name'];
    $name or $name = $args['var'];
    if (!$name) return '';
    if (isset($vars[$name]))
        $value = $vars[$name];
    if (preg_match('/^smarty_fun_[a-f0-9]+$/', $value)) {
        if (function_exists($value)) {
            ob_start();
            $value($ctx, array());
            $value = ob_get_contents();
            ob_end_clean();
        } else {
            $value = '';
        }
    }

    if ($value == '') {
        if (isset($args['default'])) {
            $value = $args['default'];
        }
    }
    if (isset($args['escape'])) {
        $esc = strtolower($args['escape']);
        if ($esc == 'js') {
            require_once("MTUtil.php");
            $value = encode_js($value);
        } elseif ($esc == 'html') {
            if (version_compare(phpversion(), '4.3.0', '>=')) {
                global $mt;
                $charset = $mt->config('PublishCharset');
                $value = htmlentities($value, ENT_COMPAT, $charset);
            } else {
                $value = htmlentities($value, ENT_COMPAT);
            }
        } elseif ($esc == 'url') {
            $value = urlencode($text);
            $value = preg_replace('/\+/', '%20', $text);
        }
    }
    return $value;
}
?>
