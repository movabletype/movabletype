<?php
function smarty_function_MTGetVar($args, &$ctx) {
    // status: complete
    // parameters: name
    $vars =& $ctx->__stash['vars'];
    if (is_array($vars)) {
        $name = $args['name'];
        if (isset($vars[$name])) {
            return $vars[$name];
        }
    }
    return '';
}
?>
