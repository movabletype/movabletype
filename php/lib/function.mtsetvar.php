<?php
function smarty_function_mtsetvar($args, &$ctx) {
    // status: complete
    // parameters: name, value
    $name = $args['name'];
    $name or $name = $args['var'];
    if (!$name) return '';
    $value = $args['value'];
    $vars =& $ctx->__stash['vars'];
    if (array_key_exists('append', $args) && $args['append']) {
        $existing = is_array($vars) ? $vars[$name] : '';
        $value = $existing . $value;
    } elseif (array_key_exists('prepend', $args) && $args['prepend']) {
        $existing = is_array($vars) ? $vars[$name] : '';
        $value = $value . $existing;
    }
    if (is_array($vars)) {
        $vars[$name] = $value;
    } else {
        $vars = array($name => $value);
        $ctx->__stash['vars'] =& $vars;
    }
    return '';
}
?>
