<?php
function smarty_function_MTSetVar($args, &$ctx) {
    // status: complete
    // parameters: name, value
    $name = $args['name'];
    $value = $args['value'];
    $vars =& $ctx->__stash['vars'];
    if (is_array($vars)) {
        $vars[$name] = $value;
    } else {
        $vars = array($name => $value);
        $ctx->__stash['vars'] =& $vars;
    }
    return '';
}
?>
