<?php
function smarty_block_mtsetvarblock($args, $content, &$ctx, &$repeat) {
    // parameters: name, value
    if (isset($content)) {
        $name = $args['name'];
        $name or $name = $args['var'];
        if (!$name) return '';
        $value = $content;
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
    }
    return '';
}
?>
